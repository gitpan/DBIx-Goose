#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'DBIx::Goose' ) || print "Bail out!\n";
}

diag( "Testing DBIx::Goose $DBIx::Goose::VERSION, Perl $], $^X" );
