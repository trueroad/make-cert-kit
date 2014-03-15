#!/bin/sh

#
# Sign and issue certificate
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
Sign and issue certificate
Copyright (C) 2014 Masamichi Hosoda

EOF

# Directory to sign
signdir=$1

# Include common configuration
# for using variable ``RANDOMSERIAL''
TOOLSDIR="$(cd "$(dirname "$0")"; pwd)"
. $TOOLSDIR/common.sh

# Include requested certificate configuration in directory to sign
. $signdir/cert.conf

startdate=$req_startdate
enddate=$req_enddate
days=$req_days
extfile=$req_extfile
extensions=$req_extensions
options=$req_options

# Include certificate configuration in this CA directory
# for using variable ``ca_conffile'', ``ca_options'', ``display_text''
. ./cert.conf

# Set startdate, enddate, days to options
if [ -n "$startdate" ]
then
    options="-startdate $startdate $options"
fi

if [ -n "$enddate" ]
then
    options="-enddate $enddate $options"
fi

if [ -n "$days" ]
then
    options="-days $days $options"
fi

# Generate random serial
$RANDOMSERIAL index.txt serial

# Check self sign
abs_path_signdir=$(cd $signdir && pwd)
abs_path_CA=`pwd`

if [ $abs_path_signdir = $abs_path_CA ]
then
    ca_options="-selfsign $ca_options"
fi

# sign
openssl ca -config $ca_conffile -in $signdir/csr.pem -out $signdir/cert.crt \
    -outdir ./newcerts -cert ./cert.crt -keyfile ./private/key.pem \
    -extfile $signdir/$extfile -extensions $extensions \
    -notext -batch $options $ca_options

if [ $display_text = "yes" ]
then
    openssl x509 -in $signdir/cert.crt -text -noout
fi
