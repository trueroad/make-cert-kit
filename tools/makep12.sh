#!/bin/sh

#
# Make pkcs#12
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
Make pkcs#12
Copyright (C) 2014 Masamichi Hosoda

EOF

# Include certificate configuration
# for using variable ``signer_ca'', ``display_text''
. ./cert.conf

dir=`pwd`
disp=$display_text
eecert="-in $dir/cert.crt -inkey $dir/private/key.pem"
certfiles=""

while [ "$signer_ca" != "." ]
do
    dir=$(cd $dir/$signer_ca && pwd);
    certfiles="$dir/cert.crt $certfiles"
    . $dir/cert.conf  # chain
done

cat $certfiles > cacerts.pem

if [ "$disp" = "yes" ]
then
    echo "eecert $eecert"
    echo "certfiles $certfiles"
fi

openssl pkcs12 -export -out cert.p12 $eecert -certfile cacerts.pem \
    -passout file:$p12_passwdfile
