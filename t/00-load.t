#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'InfluxDB::Lite' ) || print "Bail out!\n";
}

diag( "Testing InfluxDB::Lite $InfluxDB::Lite::VERSION, Perl $], $^X" );
