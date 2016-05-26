#!/usr/bin/perl -W
# Unit test for RuleManager class.

use strict;

require Rule;
require Sign;
require RuleInstance;
require RuleManager;

# Set up test
my $rule1 = new Rule( "testrule1", ["testrule2"] );
my $rule2 = new Rule( "testrule2", ["{sign1}", "testrule3"] );
my $rule2a = new Rule( "testrule2a", ["{sign1}", "testrule3"] );
my $rule2b = new Rule( "testrule2b", ["{sign1}", "testrule3"] );
my $rule3 = new Rule( "testrule3", ["{sign1}"] );
my $rule4 = new Rule( "testrule4", ["testrule4"] );
my $rule5 = new Rule( "testrule5", ["{sign1}", "testrule1", "testrule2", "{sign1}", "testrule3", "testrule3"] );

my $rm = new RuleManager();
$rm->AddRule( $rule1 );
$rm->AddRule( $rule2 );
$rm->AddRule( $rule2a );
$rm->AddRule( $rule2b );
$rm->AddRule( $rule3 );
$rm->AddRule( $rule4 );
$rm->AddRule( $rule5 );
print $rm->ListRules();


my @parts;
push @parts, new Sign("sign1");
push @parts, new RuleInstance( $rule1, [new RuleInstance( $rule2, [new Sign("sign1"), new RuleInstance( $rule3, [new Sign("sign1")])] )] );
push @parts, new RuleInstance( $rule2, [new Sign("sign1"), new RuleInstance( $rule3, [new Sign("sign1")])] );
push @parts, new Sign("sign1");
push @parts, new RuleInstance( $rule3, [new Sign("sign1")]);
push @parts, new RuleInstance( $rule3, [new Sign("sign1")]);

# Execute test
my $raMatches = $rm->MatchRules( \@parts, 0, 6 ); # Only testrule5 should match
die " 1.Wrong number:".scalar @$raMatches if scalar @$raMatches != 1;
die " 2.Wrong rule." if $raMatches->[0]->GetName() ne "testrule5";

# Execute test
$raMatches = $rm->MatchRules( \@parts, 0, 1 ); # Only testrule3 should match
die " 3.Wrong number." if scalar @$raMatches != 1;
die " 4.Wrong rule." if $raMatches->[0]->GetName() ne "testrule3";

# Execute test
$raMatches = $rm->MatchRules( \@parts, 3, 4 ); # Only testrule3 should match
die " 5.Wrong number." if scalar @$raMatches != 1;
die " 6.Wrong rule." if $raMatches->[0]->GetName() ne "testrule3";

# Execute test
$raMatches = $rm->MatchRules( \@parts, 2, 3 ); # Only testrule1 should match
die " 7.Wrong number." if scalar @$raMatches != 1;
die " 8.Wrong rule." if $raMatches->[0]->GetName() ne "testrule1";

# Execute test
$raMatches = $rm->MatchRules( \@parts, 3, 5 ); # Only testrule2, testrule2a, testrule2b should match
die " 9.Wrong number." if scalar @$raMatches != 3;
die "10.Repeated rule." if $raMatches->[0]->GetName() eq $raMatches->[1]->GetName();
die "11.Repeated rule." if $raMatches->[0]->GetName() eq $raMatches->[2]->GetName();
die "12.Repeated rule." if $raMatches->[1]->GetName() eq $raMatches->[2]->GetName();
die "13.Wrong rule." if $raMatches->[0]->GetName() ne "testrule2" && $raMatches->[0]->GetName() ne "testrule2a" && $raMatches->[0]->GetName() ne "testrule2b";
die "14.Wrong rule." if $raMatches->[1]->GetName() ne "testrule2" && $raMatches->[1]->GetName() ne "testrule2a" && $raMatches->[1]->GetName() ne "testrule2b";
die "15.Wrong rule." if $raMatches->[2]->GetName() ne "testrule2" && $raMatches->[2]->GetName() ne "testrule2a" && $raMatches->[2]->GetName() ne "testrule2b";



$rm->DeleteRules();

# Execute test
$raMatches = $rm->MatchRules( \@parts, 0, 6 ); # Nothing should match
die "16.Wrong number." if scalar @$raMatches != 0;

# Execute test
$raMatches = $rm->MatchRules( \@parts, 0, 1 ); # Nothing should match
die "17.Wrong number." if scalar @$raMatches != 0;

# Execute test
$raMatches = $rm->MatchRules( \@parts, 3, 4 ); # Nothing should match
die "18.Wrong number." if scalar @$raMatches != 0;

# Execute test
$raMatches = $rm->MatchRules( \@parts, 2, 3 ); # Nothing should match
die "19.Wrong number." if scalar @$raMatches != 0;

# Execute test
$raMatches = $rm->MatchRules( \@parts, 3, 5 ); # Nothing should match
die "20.Wrong number." if scalar @$raMatches != 0;


print "uRuleManager:pass.\n";
1;
