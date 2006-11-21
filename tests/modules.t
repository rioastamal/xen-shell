#!/usr/bin/perl -w -I..
#
#  Test that all the Perl modules we require are available.
#
#  This list is automatically generated by modules.sh
#
# Steve
# --
#

use Test::More qw( no_plan );

BEGIN{ use_ok( 'English' ); }
require_ok( 'English' );


BEGIN{ use_ok( 'File::Find' ); }
require_ok( 'File::Find' );


BEGIN{ use_ok( 'File::Temp' ); }
require_ok( 'File::Temp' );


BEGIN{ use_ok( 'Getopt::Long' ); }
require_ok( 'Getopt::Long' );


BEGIN{ use_ok( 'Pod::Usage' ); }
require_ok( 'Pod::Usage' );


BEGIN{ use_ok( 'strict' ); }
require_ok( 'strict' );


BEGIN{ use_ok( 'Test::More' ); }
require_ok( 'Test::More' );


BEGIN{ use_ok( 'warnings' ); }
require_ok( 'warnings' );


