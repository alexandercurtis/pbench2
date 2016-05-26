#!/usr/bin/perl -W
# Unit test for Cmd::Save class.

use strict;

require CommandParser;

# Set up test
my $cp = new CommandParser();
my $cmdsave = new Cmd::Save( $cp );

# Execute test
print $cmdsave->Help();
die "1.No match" if !$cmdsave->Matches("SAVE");
die "2.No match" if !$cmdsave->Matches("SAVE ");
die "3.No match" if !$cmdsave->Matches("SAVE wibble");
die "4.Match" if $cmdsave->Matches("wibble");
print $cmdsave->Execute("Wibble");
print $cmdsave->Execute("SAVE");
print $cmdsave->Execute("SAVE ");
print $cmdsave->Execute("SAVE X");

print "uCmdSave passed.";


1;
