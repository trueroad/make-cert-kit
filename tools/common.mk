#
# Common settings for makefiles
#
# Copyright (C) 2014 Masamichi Hosoda. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
# 1. Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY AUTHOR AND CONTRIBUTORS ``AS IS'' AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED.  IN NO EVENT SHALL AUTHOR OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
# SUCH DAMAGE.
#

# tools directory

TOOLSDIR := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))/

# scripts path

GENERATE_KEYPAIR := $(TOOLSDIR)generate_keypair.sh
GENERATE_CSR := $(TOOLSDIR)generate_csr.sh
PREPARE_CA := $(TOOLSDIR)prepare_ca.sh
REQUEST_SIGNATURE := $(TOOLSDIR)request_signature.sh
SIGN_CERTIFICATE := $(TOOLSDIR)sign_certificate.sh
RANDOMSERIAL := $(TOOLSDIR)randomserial.pl
MAKEP7B := $(TOOLSDIR)makep7b.sh
MAKEP12 := $(TOOLSDIR)makep12.sh

# rule

private/key.pem:
	$(GENERATE_KEYPAIR)

csr.pem:	private/key.pem
	$(GENERATE_CSR)

cert.crt:	csr.pem
	$(PREPARE_CA)
	$(REQUEST_SIGNATURE)

cert.p7b:	cert.crt
	$(MAKEP7B)

cert.p12:	cert.crt
	$(MAKEP12)

# rule for topdir

%/private/key.pem:
	$(MAKE) -C $(patsubst %/private/key.pem,%,$@) private/key.pem

%/csr.pem:
	$(MAKE) -C $(dir $@) $(notdir $@)

%/cert.crt:
	$(MAKE) -C $(dir $@) $(notdir $@)

%/cert.p7b:
	$(MAKE) -C $(dir $@) $(notdir $@)

%/cert.p12:
	$(MAKE) -C $(dir $@) $(notdir $@)

%/all:
	$(MAKE) -C $(dir $@) $(notdir $@)

%/clean:
	$(MAKE) -C $(dir $@) $(notdir $@)

# rule for clean

.PHONY:	clean

clean:
	-rm -fr private csr.pem cert.crt cert.p7b cert.p12 \
		newcerts serial serial.old \
		index.txt index.txt.attr index.txt.attr.old index.txt.old \
		cacerts.pem *~
