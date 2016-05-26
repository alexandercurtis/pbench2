#!/usr/bin/perl -W
# Unit test for Rule class.

use strict;

require Rule;
require Sign;
require RuleInstance;

# Set up test
my $rule1 = new Rule( "testrule1", ["testrule2"] );
my $rule2 = new Rule( "testrule2", ["{sign1}", "testrule3"] );
my $rule3 = new Rule( "testrule3", ["{sign1}"] );
my $rule4 = new Rule( "testrule4", ["testrule4"] );
my $rule5 = new Rule( "testrule5", ["{sign1}", "testrule1", "testrule2", "{sign1}", "testrule3", "testrule3", "testrule4"] );
my $catchallrule = new Rule( "catchall" );

my @parts1;
push @parts1, new Sign("sign1");
push @parts1, new RuleInstance( $rule1, [new RuleInstance( $rule2, [new Sign("sign1"), new RuleInstance( $rule3, [new Sign("sign1")])] )] );
push @parts1, new RuleInstance( $rule2, [new Sign("sign1"), new RuleInstance( $rule3, [new Sign("sign1")])] );
push @parts1, new Sign("sign1");
push @parts1, new RuleInstance( $rule3, [new Sign("sign1")]);
push @parts1, new RuleInstance( $rule3, [new Sign("sign1")]);
my $ri = new RuleInstance( $rule4, [] );
$ri->{m_rarParts} = [$ri];
push @parts1, $ri;

# Execute test
die " 1.Wrong name." if( $rule1->GetName() ne "testrule1");
die " 2.Wrong name." if( $rule2->GetName() ne "testrule2");
$ri = $rule1->Match( \@parts1, 2, 3);
die " 3.Wrong match." if( !defined $ri );
die " 4.Wrong RuleInstance." if ( $ri->ToString() ne "testrule1( testrule2( {sign1} testrule3( {sign1} ) ) )" );
$ri = $rule1->Match( \@parts1, 1, 2);
if( defined $ri )
{
  die " 5.Wrong match:".$ri->ToString();
}
die " 6.Wrong match." if( defined $rule1->Match( \@parts1, 1, 6) );
die " 7.Wrong match." if( defined $rule1->Match( \@parts1, 1, 0) );
die " 8.Wrong match." if( defined $rule1->Match( \@parts1, 0, 4) );
die " 9.Wrong match." if( defined $rule1->Match( \@parts1, 3, 4) );
$ri = $rule2->Match( \@parts1, 3, 5);
die "10.Wrong match." if( !defined $ri );
die "11.Wrong RuleInstance." if ( $ri->ToString() ne "testrule2( {sign1} testrule3( {sign1} ) )" );
die "12.Wrong match." if( defined $rule2->Match( \@parts1, 0, 2) );
$ri = $rule3->Match( \@parts1, 0, 1);
die "13.Wrong match." if( !defined $ri );
die "14.Wrong RuleInstance." if ( $ri->ToString() ne "testrule3( {sign1} )" );
die "15.Wrong match." if( defined $rule3->Match( \@parts1, 1, 2) );
$ri = $rule4->Match( \@parts1, 6, 7);
die "16.Wrong match." if( !defined $ri );
#die "17.Wrong RuleInstance." if ( $ri->ToString() ne "testrule4( testrule4( testrule4( ...;
die "18.Wrong match." if( defined $rule4->Match( \@parts1, 1, 2) );
die "19.Wrong match." if( !defined $rule5->Match( \@parts1, 0, 7) );

$ri = $catchallrule->Match( \@parts1, 3, 5 );
die "20.Wrong match." if( !defined $ri );
die "21.Wrong RuleInstance." if ( $ri->ToString() ne "catchall( {sign1} testrule3( {sign1} ) )" );
$ri = $catchallrule->Match( \@parts1, 0, 1 );
die "22.Wrong match." if( !defined $ri );
die "23.Wrong RuleInstance." if ( $ri->ToString() ne "catchall( {sign1} )" );
$ri = $catchallrule->Match( \@parts1, 1, 4 );
die "24.Wrong match." if( !defined $ri );
die "25.Wrong RuleInstance." if ( $ri->ToString() ne "catchall( testrule1( testrule2( {sign1} testrule3( {sign1} ) ) ) testrule2( {sign1} testrule3( {sign1} ) ) {sign1} )" );

print "uRule:pass.\n";
1;
