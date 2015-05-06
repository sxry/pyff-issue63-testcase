#!/bin/bash
export SOFTHSM_CONF=softhsm.conf
OPENSSL_CONF=openssl-debian.conf
LIBSOFT=/usr/lib/softhsm/libsofthsm.so
PIN=th3p1n
SOPIN=th3s0p1n
LABEL=signer
ID=a1b2

if [ ! -f $SOFTHSM_CONF -o ! -f $OPENSSL_CONF ]; then
   echo "Fix the paths in $0 to point to your OpenSSL and SoftHSM configuration files."
fi

/usr/bin/softhsm --slot 0 --label $LABEL --init-token --pin $PIN --so-pin $SOPIN \
    || { echo "Token init failed!"; exit -1; }

/usr/bin/pkcs11-tool --module $LIBSOFT -l -k --key-type rsa:4096 --slot 0 --id $ID --label $LABEL --pin $PIN \
    || { echo "Keypairgen failed!"; exit -1; }

/usr/bin/openssl req -new -x509 -subj "/CN=$LABEL" -engine pkcs11 -config $OPENSSL_CONF -keyform engine -key $ID -passin pass:$PIN > $LABEL.crt \
    || { echo "Cert creation failed!"; exit -1; } 

/usr/bin/openssl x509 -inform pem -outform der < $LABEL.crt > $LABEL.der \
    || { echo "Cert format conversion failed!"; exit -1; }

/usr/bin/pkcs11-tool --module $LIBSOFT -l --slot 0 --id $ID --label $LABEL -y cert -w $LABEL.der --pin $PIN \
    || { echo "Writing cert to SoftHSM failed!"; exit -1; }

/usr/bin/pkcs11-tool --module $LIBSOFT -l -O --pin $PIN \
    || { echo "Listing objects from SoftHSM failed!"; exit -1; }

echo "Looks OK."
