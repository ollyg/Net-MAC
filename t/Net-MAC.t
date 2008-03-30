# $Id: Net-MAC.t,v 1.3 2007/09/08 13:37:04 karlward Exp $

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Net-MAC.t'

#########################

use Test::More tests => 142; 
BEGIN { use_ok('Net::MAC') };

# Creating base 16 Net::MAC objects
my @macs = ();	
my $hex_mac = Net::MAC->new('mac' => '08:20:00:AB:CD:EF'); 
ok($hex_mac); 
ok($hex_mac->get_mac() eq '08:20:00:AB:CD:EF'); 
ok($hex_mac->get_bit_group() == 8); 
ok($hex_mac->get_base() == 16); 
ok($hex_mac->get_delimiter() eq ':'); 
#ok($hex_mac->get_internal_mac() eq '082000ABCDEF'); 
ok($hex_mac->get_internal_mac() eq '082000abcdef'); 

# Converting a base 16 MAC to a base 10 MAC
my $dec_mac = $hex_mac->convert(
	'base' => 10, 
	'bit_group' => 8,
	'delimiter' => '.'
); 
ok($dec_mac); 
ok($dec_mac->get_mac() eq '8.32.0.171.205.239'); 
ok($dec_mac->get_bit_group() == 8); 
ok($dec_mac->get_base() == 10); 

# Converting a base 10 MAC to a base 16 MAC
my $hex_mac_2 = $dec_mac->convert(
	'base' => 16, 
	'bit_group' => 16, 
	'delimiter' => ':'
); 
ok($hex_mac_2); 
ok($hex_mac_2->get_mac() eq '0820:00ab:cdef'); 
ok($hex_mac_2->get_bit_group() == 16);
ok($hex_mac_2->get_base() == 16);
ok($hex_mac_2->get_internal_mac() eq '082000abcdef');

# Creating a base 10 Net::MAC object
my $dec_mac_2 = Net::MAC->new(
	'mac' => '0.7.14.6.43.3', 
	'base' => 10
); 
ok($dec_mac_2); 
ok($dec_mac_2->get_mac() eq '0.7.14.6.43.3'); 
ok($dec_mac_2->get_bit_group() == 8); 
ok($dec_mac_2->get_base() == 10); 
ok($dec_mac_2->get_internal_mac() eq '00070e062b03'); 

my $hex_mac_3 = $dec_mac_2->convert(
	'base' => 16, 
	'bit_group' => 16, 
	'delimiter' => '.'
); 
ok($hex_mac_3); 
ok($hex_mac_3->get_mac() eq '0007.0e06.2b03');
ok($hex_mac_3->get_bit_group() == 16); 
ok($hex_mac_3->get_base() == 16); 
ok($hex_mac_3->get_internal_mac() eq '00070e062b03');

# Creating a base 16 dash delimited Net::MAC object
my $hex_mac_4 = Net::MAC->new('mac' => '12-23-34-45-a4-ff'); 
ok($hex_mac_4); 
ok($hex_mac_4->get_mac() eq '12-23-34-45-a4-ff');
ok($hex_mac_4->get_bit_group() == 8);
ok($hex_mac_4->get_base() == 16);
ok($hex_mac_4->get_internal_mac() eq '12233445a4ff'); 


my (%delim_mac) = ( 
	'.' => ['08.00.20.ab.cd.ef', '8.0.20.ab.cd.ef', '08.00.20.AB.CD.EF', '122.255.0.16.1.1'], 
	':' => ['08:00:20:ab:cd:ef', '8:0:20:ab:cd:ef', '08:00:20:AB:CD:EF'], 
	'-' => ['08-00-20-ab-cd-ef', '8-0-20-ab-cd-ef', '08-00-20-AB-CD-EF'], 
	' ' => ['08 00 20 ab cd ef', '8 0 20 ab cd ef', '08 00 20 AB CD EF'],
	'none' => ['080020abcdef', '080020ABCDEF'], 
);
foreach my $delim (keys %delim_mac) { 
	diag "testing delimiter \"$delim\""; 
	foreach my $test_mac (@{$delim_mac{$delim}}) { 
		my $mac = Net::MAC->new('mac' => $test_mac);
		ok($mac, $test_mac); 
		my $test_delim = $mac->get_delimiter(); 
		if ($delim eq 'none') { 
			#diag "null delimiter"; 
			ok(!defined($test_delim), 'delimiter \"none\"'); 
		} 
		else { 
			#diag "delimiter \"$delim\" MAC \"$test_mac\""; 
			ok($test_delim eq $delim, "delimiter \"$delim\""); 
		}
	}
}
my (%base_mac) = ( 
	'10' => ['122.255.0.16.1.1', '0.0.90.12.255.255', '8.0.20.55.1.1'], 
	'16' => ['08.00.20.ab.cd.ef', '8:0:20:ab:cd:ef', '8:0:20:AB:CD:EF']
); 
foreach my $base (keys %base_mac) { 
	diag "testing base \"$base\""; 
	foreach my $test_mac_2 (@{$base_mac{$base}}) { 
		my $mac = Net::MAC->new(
			'mac' => $test_mac_2, 
			'base' => $base
		); 
		ok($mac, $test_mac_2);
		my $mac_base = $mac->get_base(); 
		#diag "base is $mac_base, MAC is $test_mac_2";
		ok($mac_base == $base, "base $base"); 
	} 
}

my (%bit_mac) = ( 
	48 => ['8080abe4c9ff', '8080ABE4C9FF', 'ABCDEFABCDEF', '0123456789ab'], 
	16 => ['8080.abe4.c9ff', '8080.ABE4.C9FF', 'ABCD.EFAB.CDEF', '0123.4567.89ab'], 
	8 => ['80.80.ab.e4.c9.ff', '80:80:ab:e4:c9:ff', '80-80-ab-e4-c9-ff', '80 80 AB E4 C9 FF']
); 
foreach my $bit (keys %bit_mac) { 
	diag "testing bit grouping \"$bit\""; 
	foreach my $test_mac_3 (@{$bit_mac{$bit}}) { 
		my $mac = Net::MAC->new('mac' => $test_mac_3); 
		ok($mac, $test_mac_3); 
		my $mac_bit = $mac->get_bit_group(); 
		ok($mac_bit == $bit, "bit grouping $bit"); 
	} 
}

# Test against a battery of base 16 MAC addresses 
my @mac = ('08.00.20.ab.cd.ef', '8:0:20:ab:cd:ef', '8:0:20:AB:CD:EF', '8080abe4c9ff', '8080ABE4C9FF', 'ABCDEFABCDEF', '0123456789ab', '8080.abe4.c9ff', '8080.ABE4.C9FF', 'ABCD.EFAB.CDEF', '0123.4567.89ab', '80.80.ab.e4.c9.ff', '80:80:ab:e4:c9:ff', '80-80-ab-e4-c9-ff', '80 80 AB E4 C9 FF'); 

foreach my $test_mac (@mac) {  
	ok(Net::MAC->new('mac' => $test_mac)); 
} 

diag("testing some invalid MAC addresses"); 
no warnings; 
my @invalid_mac = (':::::', ' : : : : : ', '..', '\s\s\s\s\s', '-----', '---', ' - - ', ' ', '99.6', '888:76.12', '1', '000000000000000000111111', '256.256.256.256.256.256', '128.123.123.234.345.456', 'abcdefghijkl'); 
foreach my $invalid_mac (@invalid_mac) { 
	my $no_die = Net::MAC->new(mac => $invalid_mac, die => 0); 
	ok($no_die, "testing 'die' attribute"); 
	diag("testing invalid MAC $invalid_mac\n");
	ok($no_die->get_error(), "testing get_error() method"); 
	#diag($no_die->get_error());
}
use warnings;

