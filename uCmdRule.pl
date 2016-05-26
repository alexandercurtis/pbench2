#!/usr/bin/perl -W
# Unit test for Cmd::Rule class.

use strict;

require Rule;
require Sign;
require RuleInstance;
require RuleManager;
require CommandParser;

# Set up test
my $rm = new RuleManager();
my $cp = new CommandParser( $rm );
my $cmdrule = new Cmd::Rule( $cp );

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

my @parts;
push @parts, new RuleInstance( $ruleb, [$signb] );
push @parts, new RuleInstance( $rulec, [$signc] );
push @parts, new RuleInstance( $ruled, [$signd] );
push @parts, new RuleInstance( $rulee, [$signe] );
push @parts, new Sign("cat");
push @parts, new Sign("dog");
push @parts, new RuleInstance( $rulef, [$signf] );

# Execute test
print $cmdrule->Help();
die "1.No match" if !$cmdrule->Matches("RULE");
die "2.No match" if !$cmdrule->Matches("RULE ");
die "3.No match" if !$cmdrule->Matches("RULE wibble");
die "4.Match" if $cmdrule->Matches("wibble");

die("1.Rule make didn't fail.") if( $cmdrule->Execute("RULE badlyformed") !~ m/^Bad rule syntax/ );
die("2.Rule make failed.") if $cmdrule->Execute("RULE A=B") ne "A = B\n";
die("3.Rule make failed.") if $cmdrule->Execute("RULE B=C+D+E") ne "B = C + D + E\n";
die("4.Rule make failed.") if $cmdrule->Execute("RULE C={cat}") ne "C = {cat}\n";
die("5.Rule make failed.") if $cmdrule->Execute("RULE D={dog}+F") ne "D = {dog} + F\n";
die("6.Rule make failed.") if $cmdrule->Execute("RULE G  =  H  +  I  ") ne "G = H + I\n";
die("7.Rule make didn't fail properly.") if $cmdrule->Execute("RULE J={K+L") !~ m/^Badly formed sign/;
die("8.Rule make didn't fail properly.") if $cmdrule->Execute("RULE M=N}+0") !~ m/^Badly formed part/;
die("9.Rule make didn't fail properly.") if $cmdrule->Execute("RULE P=Q+{}") !~ m/^Empty sign/;
die("10.Rule make didn't fail properly.") if $cmdrule->Execute("RULE R=S+{") !~ m/^Badly formed sign/;
die("11.Rule make didn't fail properly.") if $cmdrule->Execute("RULE T={") !~ m/^Badly formed sign/;
die("12.Rule make didn't fail properly.") if $cmdrule->Execute("RULE U={A{B}") !~ m/^Badly formed sign/;
die("13.Rule make didn't fail properly.") if $cmdrule->Execute("RULE U={A}B}") !~ m/^Badly formed sign/;
die("14.Rule make didn't fail properly.") if $cmdrule->Execute("RULE U=A{B") !~ m/^Badly formed part/;
die("15.Rule make didn't fail properly.") if $cmdrule->Execute("RULE U=A}B") !~ m/^Badly formed part/;
die("16.Rule make didn't fail properly.") if $cmdrule->Execute("RULE U=A{B}") !~ m/^Badly formed part/;
die("17.Rule make didn't fail properly.") if $cmdrule->Execute("RULE U=A}B}") !~ m/^Badly formed part/;
die("18.Rule make didn't fail properly.") if $cmdrule->Execute("RULE {U=B") !~ m/^Bad rule syntax/;
die("19.Rule make didn't fail properly.") if $cmdrule->Execute("RULE U}=B") !~ m/^Bad rule syntax/;
die("20.Rule make didn't fail properly.") if $cmdrule->Execute("RULE {U}=B") !~ m/^Bad rule syntax/;
die("21.Rule make didn't fail properly.") if $cmdrule->Execute("RULE {U{V}=B") !~ m/^Bad rule syntax/;
die("22.Rule make didn't fail properly.") if $cmdrule->Execute("RULE U}V=B") !~ m/^Bad rule syntax/;
die("23.Rule make didn't fail properly.") if $cmdrule->Execute("RULE") !~ m/^No rule made./;

print "uCmdRule passed.";

1;
