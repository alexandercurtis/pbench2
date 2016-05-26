#!/usr/bin/perl -W
# Unit test for Sign class.

use strict;

require Sign;

# Set up test
my $sign1 = new Sign( "sign1" );

# Execute test
die " 1.Wrong name." if $sign1->GetName() ne "{sign1}";
die " 2.Wrong string." if $sign1->ToString() ne "{sign1}";
die " 3.Hash touched." if exists( $Sign::hSigns{"sign1"} );
die " 4.Hash size wrong." if keys(%Sign::hSigns) != 0;

my $sign2 = Sign::GetOrCreate("sign2");
die " 5.Wrong name." if $sign2->GetName() ne "{sign2}";
die " 6.Wrong string." if $sign2->ToString() ne "{sign2}";
die " 7.Hash not touched." if !exists( $Sign::hSigns{"sign2"} );
die " 8.Hash size wrong." if keys(%Sign::hSigns) != 1;

my $sign3 = Sign::GetOrCreate("sign3");
die " 9.Wrong name." if $sign3->GetName() ne "{sign3}";
die "10.Wrong string." if $sign3->ToString() ne "{sign3}";
die "11.Hash not touched." if !exists( $Sign::hSigns{"sign3"} );
die "12.Hash size wrong." if keys(%Sign::hSigns) != 2;

my $sign4 = Sign::GetOrCreate("sign2");
die "13.Wrong name." if $sign4->GetName() ne "{sign2}";
die "14.Wrong string." if $sign4->ToString() ne "{sign2}";
die "15.Hash not touched." if !exists( $Sign::hSigns{"sign2"} );
die "16.Hash size wrong." if keys(%Sign::hSigns) != 2;

print "uSign:pass\n";
1;

