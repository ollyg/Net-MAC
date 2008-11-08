use inc::Module::Install 0.67;
perl_version '5.008001';
  
name        'Net-MAC';
all_from    'lib/Net/MAC.pm';

test_requires  'Test::More' => 0;
test_requires  'Test::Pod' => 0;
test_requires  'Test::Pod::Coverage' => 0;

WriteAll;

