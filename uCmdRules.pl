#!/usr/bin/perl -W
# Unit test for Cmd::Rules class.

use strict;

require Rule;
require Sign;
require RuleInstance;
require RuleManager;
require CommandParser;

# Set up test
my $rm = new RuleManager();
my $cp = new CommandParser( $rm );
my $cmdrules = new Cmd::Rules( $cp );

my $signa = new Sign( "SA" );
my $signb = new Sign( "SB" );
my $signc = new Sign( "SC" );
my $signd = new Sign( "SD" );
my $signe = new Sign( "SE" );
my $signf = new Sign( "SF" );
my $rulea = new Rule( "A", ["SA"] );
my $ruleb = new Rule( "B", ["SB"] );
my $rulec = new Rule( "C", ["SC"] );
my $ruled = new Rule( "D", ["SD"] );
my $rulee = new Rule( "E", ["SE"] );
my $rulef = new Rule( "F", ["SF"] );

$rm->AddRule( $rulea );
$rm->AddRule( $ruleb );
$rm->AddRule( $rulec );
$rm->AddRule( $ruled );
$rm->AddRule( $rulee );
$rm->AddRule( $rulef );

# Execute test
print $cmdrules->Help();
print $cmdrules->Execute("RULES");

print "uCmdRules passed.";

1;
