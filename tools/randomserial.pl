#!/usr/bin/perl

#
# Random serial maker for openssl ca command
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

print << "EOF";
Random serial maker for openssl ca command
Copyright (C) 2014 Masamichi Hosoda

EOF

$databasefile=$ARGV[0];
$serialfile=$ARGV[1];

# Random source and serial size (byte)
$randomfile="/dev/random";
$serialsize=16;  # MUST NOT use values longer than 20 octets. (RFC5280 4.1.2.2)

# Generate random serial number.
sub genrand
{
    open(FRAND, $randomfile);
    my $randdata;
    read(FRAND, $randdata, $serialsize);
    close(FRAND);

    my $randtext=uc(unpack("H*", $randdata));

    # CAs MUST force the serialNumber to be a non-negative integer. (RFC5280)
    my $firstletter=substr($randtext, 0, 1);
    $firstletter =~ tr/[89A-F]/[0-7]/;  # MSB is set to zero (non-negative).
    $randtext = $firstletter . substr($randtext, 1);

    return $randtext;
}

# Find existing serial number from database.
sub findserial
{
    my ($db_filename, $serial) = @_;

    open(FIN, $db_filename);

    while(my $line=<FIN>)
    {
	if($line =~ /$serial/)
	{
	    close(FIN);
	    return 1;  # DB has same serial number.
	}
    }
    close(FIN);
    return 0;  # DB doesn't have same serial number.
}

# Generate random serial number until it is different
# from all existing serial number at database.
do
{
    $r=&genrand;
}while(&findserial($databasefile, $r));

print "serial " . $r . "\n";

open(FOUT, ">$serialfile");
print FOUT $r;
close(FOUT);
