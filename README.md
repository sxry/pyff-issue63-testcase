pyff issue 63 test case
-----------------------

Steps to reproduce, tested on Debian GNU/Linux 7 or CentOS 6:

1. Install `softhsm`, `opensc` and `engine_pkcs11` packages. For the latter:
  * Debian: `libengine-pkcs11-openssl`
  * CentOS: 3rd-party RPMs for `libp11` and `engine_pkcs11` are available from http://rnd.rajven.net/centos/
2. Setup your virtualenv and install pyFF and dependencies, incl `pykcs11`
3. Source the virtualenv so that the `pyff` executable becomes available in your `$PATH`
4. Clone this repo and cd into it
5. `make debian` or `make centos`, depending on your distribution to create `output.xml`
That will setup a symlink to config files with the appropriate library paths (asuming `x86_64`), initate the `softhsm.db` with a new key pair and call pyFF on the `p11.fd` pipeline.
6. `make test` to see that the `ds:Signature` element is missing a `ds:KeyInfo` element with a `ds:X509Certificate` element in it.
