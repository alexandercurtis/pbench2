#!/usr/bin/perl -W
# Unit test for Cmd::New class.

use strict;

require Rule;
require Sign;
require RuleInstance;
require RuleManager;
require CommandParser;

# Set up test
my $rule1 = new Rule( "testrule1", ["testrule2"] );
my $rule2 = new Rule( "testrule2", ["sign1", "testrule3"] );
my $rule2a = new Rule( "testrule2a", ["sign1", "testrule3"] );
my $rule2b = new Rule( "testrule2b", ["sign1", "testrule3"] );
my $rule3 = new Rule( "testrule3", ["sign1"] );
my $rule4 = new Rule( "testrule4", ["testrule4"] );
my $rule5 = new Rule( "testrule5", ["sign1", "testrule1", "testrule2", "sign1", "testrule3", "testrule3"] );

my $rm = new RuleManager();
$rm->AddRule( $rule1 );
$rm->AddRule( $rule2 );
$rm->AddRule( $rule2a );
$rm->AddRule( $rule2b );
$rm->AddRule( $rule3 );
$rm->AddRule( $rule4 );
$rm->AddRule( $rule5 );
die "0.Rules wrong:".scalar(@{$rm->{m_rarRules}}) if scalar(@{$rm->{m_rarRules}}) != 7;

my $cp = new CommandParser( $rm );
my $cmdnew = new Cmd::New( $cp );

# Execute test
print $cmdnew->Help();
die "1.No match" if !$cmdnew->Matches("NEW");
die "2.No match" if !$cmdnew->Matches("NEW ");
die "3.Match" if $cmdnew->Matches("NEW wibble");
die "4.Match" if $cmdnew->Matches("wibble");

die "1.Rules wrong:".scalar(@{$rm->{m_rarRules}}) if scalar(@{$rm->{m_rarRules}}) != 7;

print $cmdnew->Execute("Wibble");
die "2.Rules wrong" if scalar(@{$rm->{m_rarRules}}) != 7;

print $cmdnew->Execute("NEW");
die "3.Rules remain" if scalar(@{$rm->{m_rarRules}}) != 0;

$rm->AddRule( $rule1 );
$rm->AddRule( $rule2 );
die "4.Rules wrong" if scalar(@{$rm->{m_rarRules}}) != 2;
print $cmdnew->Execute("NEW ");
die "5.Rules remain" if scalar(@{$rm->{m_rarRules}}) != 0;

$rm->AddRule( $rule1 );
$rm->AddRule( $rule2 );
die "6.Rules wrong" if scalar(@{$rm->{m_rarRules}}) != 2;
print $cmdnew->Execute("NEW X"); # Should not match NEW command
die "7.Rules wrong" if scalar(@{$rm->{m_rarRules}}) != 2;


print "uCmdNew passed.";

1;
