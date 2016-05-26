#!/usr/bin/perl -W
# Unit test for RuleInstance class.

use strict;

require Rule;
require Sign;
require RuleInstance;

# Set up test
my $rule1 = new Rule( "testrule1", ["test1"] );
my @parts1;
push @parts1, new Sign("test1");
my $ri1 = new RuleInstance( $rule1, \@parts1 );

# Execute test
die "1.Wrong name." if $ri1->GetName() ne "testrule1";
my $res = $ri1->ToString();
die "1.Wrong ToString <$res>." if $res ne "testrule1( {test1} )";

# Set up test
my $rule2 = new Rule( "testrule2", ["testrule1", "test2b"] );
my @parts2;
push @parts2, $ri1;
push @parts2, new Sign("test2b");
my $ri2 = new RuleInstance( $rule2, \@parts2 );

# Execute test
die "2.Wrong name." if $ri2->GetName() ne "testrule2";
$res = $ri2->ToString();
die "2.Wrong ToString <$res>." if $res ne "testrule2( testrule1( {test1} ) {test2b} )";

# Set up test
my $rule3 = new Rule( "testrule3", ["testrule1", "test3", "testrule2"] );
my @parts3;
push @parts3, $ri1;
push @parts3, new Sign("test3");
push @parts3, $ri2;
my $ri3 = new RuleInstance( $rule3, \@parts3 );

# Execute test
die "3.Wrong name." if $ri3->GetName() ne "testrule3";
die "3.Wrong ToString." if $ri3->ToString() ne "testrule3( testrule1( {test1} ) {test3} testrule2( testrule1( {test1} ) {test2b} ) )";

print "uRuleInstance:pass.\n";
1;
