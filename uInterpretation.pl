#!/usr/bin/perl -W
# Unit test for Interpretation class.

use strict;

require Rule;
require Sign;
require RuleInstance;
require RuleManager;
require Interpretation;

# Set up test
my $rule1 = new Rule( "R1", ["R2"] );
my $rule2 = new Rule( "R2", ["{S1}", "R3"] );
my $rule2a = new Rule( "R2a", ["{S1}", "R3"] );
my $rule2b = new Rule( "R2b", ["{S1}", "R3"] );
my $rule3 = new Rule( "R3", ["{S1}"] );
my $rule4 = new Rule( "R4", ["R4"] );
my $rule5 = new Rule( "R5", ["{S1}", "R1", "R2", "{S1}", "R3", "R3"] );

my @parts;
push @parts, new Sign("S1");
push @parts, new RuleInstance( $rule1, [new RuleInstance( $rule2, [new Sign("S1"), new RuleInstance( $rule3, [new Sign("S1")])] )] );
push @parts, new RuleInstance( $rule2, [new Sign("S1"), new RuleInstance( $rule3, [new Sign("S1")])] );
push @parts, new Sign("S1");
push @parts, new RuleInstance( $rule3, [new Sign("S1")]);
push @parts, new RuleInstance( $rule3, [new Sign("S1")]);
my $interpretation = new Interpretation( \@parts );

my $rm = new RuleManager();
$rm->AddRule( $rule1 );
$rm->AddRule( $rule2 );
$rm->AddRule( $rule2a );
$rm->AddRule( $rule2b );
$rm->AddRule( $rule3 );
$rm->AddRule( $rule4 );
$rm->AddRule( $rule5 );



# Execute test
die " 1.Wrong string:".$interpretation->ToString() if $interpretation->ToString() ne "{S1} R1( R2( {S1} R3( {S1} ) ) ) R2( {S1} R3( {S1} ) ) {S1} R3( {S1} ) R3( {S1} )";
die " 2.Wrong string:".$interpretation->ToShortString() if $interpretation->ToShortString() ne "{S1} R1 R2 {S1} R3 R3";

# Execute test
my @aInterpretationsNew = ();
$interpretation->ApplyRules( $rm, [], \@aInterpretationsNew, 0 );

die " 3.Wrong number of interpretations:" . scalar(@aInterpretationsNew) if @aInterpretationsNew != 20;

# Note that these tests expect the interpretations in a particular order,
# but actually the design doesn't care about the order, so we might have
# to relax this test in future to not care about order but just check if
# the intrepretation is present.
die " 4.Wrong interpretation<" . $aInterpretationsNew[0]->ToString() . ">." if( $aInterpretationsNew[0]->ToString() ne "R5( {S1} R1( R2( {S1} R3( {S1} ) ) ) R2( {S1} R3( {S1} ) ) {S1} R3( {S1} ) R3( {S1} ) )" );
die " 5.Wrong interpretation." if( $aInterpretationsNew[1]->ToString() ne "{S1} R1( R2( {S1} R3( {S1} ) ) ) R2( {S1} R3( {S1} ) ) R2( {S1} R3( {S1} ) ) R3( {S1} )" );
die " 6.Wrong interpretation." if( $aInterpretationsNew[2]->ToString() ne "{S1} R1( R2( {S1} R3( {S1} ) ) ) R2( {S1} R3( {S1} ) ) R2a( {S1} R3( {S1} ) ) R3( {S1} )" );
die " 7.Wrong interpretation." if( $aInterpretationsNew[3]->ToString() ne "{S1} R1( R2( {S1} R3( {S1} ) ) ) R2( {S1} R3( {S1} ) ) R2b( {S1} R3( {S1} ) ) R3( {S1} )" );
die " 8.Wrong interpretation." if( $aInterpretationsNew[4]->ToString() ne "{S1} R1( R2( {S1} R3( {S1} ) ) ) R2( {S1} R3( {S1} ) ) R3( {S1} ) R3( {S1} ) R3( {S1} )" );
die " 9.Wrong interpretation." if( $aInterpretationsNew[5]->ToString() ne "{S1} R1( R2( {S1} R3( {S1} ) ) ) R1( R2( {S1} R3( {S1} ) ) ) {S1} R3( {S1} ) R3( {S1} )" );
die "10.Wrong interpretation." if( $aInterpretationsNew[6]->ToString() ne "{S1} R1( R2( {S1} R3( {S1} ) ) ) R1( R2( {S1} R3( {S1} ) ) ) R2( {S1} R3( {S1} ) ) R3( {S1} )" );
die "11.Wrong interpretation." if( $aInterpretationsNew[7]->ToString() ne "{S1} R1( R2( {S1} R3( {S1} ) ) ) R1( R2( {S1} R3( {S1} ) ) ) R2a( {S1} R3( {S1} ) ) R3( {S1} )" );
die "12.Wrong interpretation." if( $aInterpretationsNew[8]->ToString() ne "{S1} R1( R2( {S1} R3( {S1} ) ) ) R1( R2( {S1} R3( {S1} ) ) ) R2b( {S1} R3( {S1} ) ) R3( {S1} )" );
die "13.Wrong interpretation." if( $aInterpretationsNew[9]->ToString() ne "{S1} R1( R2( {S1} R3( {S1} ) ) ) R1( R2( {S1} R3( {S1} ) ) ) R3( {S1} ) R3( {S1} ) R3( {S1} )" );
die "14.Wrong interpretation." if( $aInterpretationsNew[10]->ToString() ne "R3( {S1} ) R1( R2( {S1} R3( {S1} ) ) ) R2( {S1} R3( {S1} ) ) {S1} R3( {S1} ) R3( {S1} )" );
die "15.Wrong interpretation." if( $aInterpretationsNew[11]->ToString() ne "R3( {S1} ) R1( R2( {S1} R3( {S1} ) ) ) R2( {S1} R3( {S1} ) ) R2( {S1} R3( {S1} ) ) R3( {S1} )" );
die "16.Wrong interpretation." if( $aInterpretationsNew[12]->ToString() ne "R3( {S1} ) R1( R2( {S1} R3( {S1} ) ) ) R2( {S1} R3( {S1} ) ) R2a( {S1} R3( {S1} ) ) R3( {S1} )" );
die "17.Wrong interpretation." if( $aInterpretationsNew[13]->ToString() ne "R3( {S1} ) R1( R2( {S1} R3( {S1} ) ) ) R2( {S1} R3( {S1} ) ) R2b( {S1} R3( {S1} ) ) R3( {S1} )" );
die "18.Wrong interpretation." if( $aInterpretationsNew[14]->ToString() ne "R3( {S1} ) R1( R2( {S1} R3( {S1} ) ) ) R2( {S1} R3( {S1} ) ) R3( {S1} ) R3( {S1} ) R3( {S1} )" );
die "19.Wrong interpretation." if( $aInterpretationsNew[15]->ToString() ne "R3( {S1} ) R1( R2( {S1} R3( {S1} ) ) ) R1( R2( {S1} R3( {S1} ) ) ) {S1} R3( {S1} ) R3( {S1} )" );
die "20.Wrong interpretation." if( $aInterpretationsNew[16]->ToString() ne "R3( {S1} ) R1( R2( {S1} R3( {S1} ) ) ) R1( R2( {S1} R3( {S1} ) ) ) R2( {S1} R3( {S1} ) ) R3( {S1} )" );
die "21.Wrong interpretation." if( $aInterpretationsNew[17]->ToString() ne "R3( {S1} ) R1( R2( {S1} R3( {S1} ) ) ) R1( R2( {S1} R3( {S1} ) ) ) R2a( {S1} R3( {S1} ) ) R3( {S1} )" );
die "22.Wrong interpretation." if( $aInterpretationsNew[18]->ToString() ne "R3( {S1} ) R1( R2( {S1} R3( {S1} ) ) ) R1( R2( {S1} R3( {S1} ) ) ) R2b( {S1} R3( {S1} ) ) R3( {S1} )" );
die "23.Wrong interpretation." if( $aInterpretationsNew[19]->ToString() ne "R3( {S1} ) R1( R2( {S1} R3( {S1} ) ) ) R1( R2( {S1} R3( {S1} ) ) ) R3( {S1} ) R3( {S1} ) R3( {S1} )" );

print "uInterpretation:pass.\n";
1;
