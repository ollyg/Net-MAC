# $Id$

use Test::More tests => 5;
#use Test::More qw(no_plan);
BEGIN { use_ok('Net::MAC') };

my $macaddr = '01:ab:01:ab:01:ab';

my $mac = eval{ Net::MAC->new(mac => $macaddr) };
isa_ok($mac, 'Net::MAC');

my $mac_defaults = $mac->convert;
is($mac_defaults, '01ab01ab01ab', 'convert() using defaults');

my $mac_bitgroup = $mac->convert(bit_group => 8);
is($mac_bitgroup, '01:ab:01:ab:01:ab', 'convert() using bit_group and default delimiter');

my $mac_bitgroup_delim = $mac->convert(bit_group => 8, delimiter => '-');
is($mac_bitgroup_delim, '01-ab-01-ab-01-ab', 'convert() using bit_group and hyphen delimiter');

