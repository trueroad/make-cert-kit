#!/bin/sh

#
# Generate keypair
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

cat <<EOF
Generate keypair
Copyright (C) 2014 Masamichi Hosoda

EOF

# Include certificate configuration
# for using variable ``key_algorithm'', ``key_options'', ``display_text''
. ./cert.conf

# Default options for each algorithm
default_options_RSA="-pkeyopt rsa_keygen_bits:2048"
default_options_DSA="-pkeyopt dsa_paramgen_bits:2048"
default_options_EC="-pkeyopt ec_paramgen_curve:prime256v1"  # Don't use EC
default_options_ECC="-name prime256v1"

if [ ! $key_algorithm ]
then
    key_algorithm="RSA"
fi

if [ ! -d private ]
then
    mkdir private
    chmod 700 private
fi

cd private

if [ ! -f key.pem ]
then
    default_options=$(eval 'echo $default_options_'$key_algorithm)

    case $key_algorithm in
	RSA)
	    openssl genpkey -out key.pem -algorithm $key_algorithm \
		$default_options $key_options
	    ;;
	ECC)
	    if [ ! -f parameter.pem ]
	    then
		openssl ecparam -out parameter.pem \
		    $default_options $key_options
	    fi
	    openssl genpkey -out key.pem -paramfile parameter.pem
	    ;;
	DSA | EC)  # Don't use EC.
	    if [ ! -f parameter.pem ]
	    then
		openssl genpkey -genparam -out parameter.pem \
		    -algorithm $key_algorithm $default_options $key_options
	    fi
	    openssl genpkey -out key.pem -paramfile parameter.pem
	    ;;
    esac

    chmod 400 key.pem

    if [ "$display_text" = "yes" ]
    then
	if [ -f parameter.pem ]
	then
	    openssl pkeyparam -in parameter.pem -text
	fi
	openssl pkey -in key.pem -text
    fi

fi

cd ..
