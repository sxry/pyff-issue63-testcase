.PHONY: test debian centos

all: output.xml

output.xml: softhsm.db
	PYKCS11PIN=th3p1n pyff --loglevel=INFO p11.fd

softhsm.db: softhsm.conf p11setup.sh
	./p11setup.sh

test: output.xml elemonly.xsl
	xmllint --format output.xml | head -20

clean:
	rm -rf softhsm.db signer.crt signer.der output.xml .cache p11setup.sh

debian: p11setup-debian.sh
	ln -sf p11setup-debian.sh p11setup.sh
	@make output.xml

centos: p11setup-centos.sh
	ln -sf p11setup-centos.sh p11setup.sh
	@make output.xml

