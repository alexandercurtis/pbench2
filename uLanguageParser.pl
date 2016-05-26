#!/usr/bin/perl -W
# Unit test for LanguageParser class.

# Work in progress

use strict;

require Rule;
require Sign;
require RuleInstance;
require Interpretation;
require LanguageParser;

# Set up test
my $lp = new LanguageParser();

my @arInterpretations = ();

my $rule1 = new Rule( "R1", ["R2"] );
my $rule2 = new Rule( "R2", ["S1", "R3"] );
my $rule2a = new Rule( "R2a", ["S1", "R3"] );
my $rule2b = new Rule( "R2b", ["S1", "R3"] );
my $rule3 = new Rule( "R3", ["S1"] );
my $rule4 = new Rule( "R4", ["R4"] );
my $rule5 = new Rule( "R5", ["S1", "R1", "R2", "S1", "R3", "R3"] );

# Execute test

$lp->Permute( [], "A B C D" );
my @permutations = ();
my @arPermInterpretations = (values %{$lp->{m_rhInterpretations}});
foreach my $rPermIntrepretation (@arPermInterpretations)
{
  push @permutations, $rPermIntrepretation->ToShortString();
}
my @sortedPerms = sort( @permutations );


die " 1.Wrong number of perms:".scalar(@sortedPerms) if @sortedPerms  != 8;
die " 2.Wrong permutation:".$sortedPerms[0] if $sortedPerms[0] ne "{A B C D}";
die " 3.Wrong permutation:".$sortedPerms[1] if $sortedPerms[1] ne "{A B C} {D}";
die " 4.Wrong permutation:".$sortedPerms[2] if $sortedPerms[2] ne "{A B} {C D}";
die " 5.Wrong permutation:".$sortedPerms[3] if $sortedPerms[3] ne "{A B} {C} {D}";
die " 6.Wrong permutation:".$sortedPerms[4] if $sortedPerms[4] ne "{A} {B C D}";
die " 7.Wrong permutation:".$sortedPerms[5] if $sortedPerms[5] ne "{A} {B C} {D}";
die " 8.Wrong permutation:".$sortedPerms[6] if $sortedPerms[6] ne "{A} {B} {C D}";
die " 9.Wrong permutation:".$sortedPerms[7] if $sortedPerms[7] ne "{A} {B} {C} {D}";

# Set up test

my @parts1 = ();
push @parts1, new Sign("S2");
push @parts1, new Sign("S3");
push @arInterpretations, new Interpretation( \@parts1 );

my @parts2 = ();
push @parts2, new Sign("S1");
push @parts2, new RuleInstance( $rule1, [new RuleInstance( $rule2, [new Sign("S1"), new RuleInstance( $rule3, [new Sign("S1")])] )] );
push @parts2, new RuleInstance( $rule2, [new Sign("S1"), new RuleInstance( $rule3, [new Sign("S1")])] );
push @parts2, new Sign("S1");
push @parts2, new RuleInstance( $rule3, [new Sign("S1")]);
push @parts2, new RuleInstance( $rule3, [new Sign("S1")]);
push @arInterpretations, new Interpretation( \@parts2 );

# Execute test

$lp->AddInterpretations( \@arInterpretations );
die "10.Wrong number of interps:".scalar(keys %{$lp->{m_rhInterpretations}}) if keys %{$lp->{m_rhInterpretations}} != 10;
$lp->AddInterpretations( \@arInterpretations );
die "11.Wrong number of interps:".scalar(keys %{$lp->{m_rhInterpretations}}) if keys %{$lp->{m_rhInterpretations}} != 10;

my $lp2 = new LanguageParser();
$lp2->Permute( [], "" );
die "12.Permuations" if scalar(values %{$lp2->{m_rhInterpretations}}) != 0;

print "uLanguageParser:pass.\n";
1;
