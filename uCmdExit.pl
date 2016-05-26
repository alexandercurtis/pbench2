#!/usr/bin/perl -W
# Unit test for Cmd::Exit class.

use strict;

require CommandParser;

# Set up test
my $cp = new CommandParser();
my $cmdexit = new Cmd::Exit( $cp );

# Execute test
print $cmdexit->Help();
die "1.No match" if !$cmdexit->Matches("EXIT");
die "2.No match" if !$cmdexit->Matches("EXIT ");
die "3.Match" if $cmdexit->Matches("EXIT wibble");
die "4.Match" if $cmdexit->Matches("wibble");
print $cmdexit->Execute("Wibble");
print "uCmdExit passed.";
print $cmdexit->Execute("EXIT");

print "uCmdExit failed - should have exited before now.";

1;
