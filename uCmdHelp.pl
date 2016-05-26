#!/usr/bin/perl -W
# Unit test for Cmd::Help class.

use strict;

require CommandParser;

# Set up test
my $cp = new CommandParser();
my $cmdhelp = new Cmd::Help( $cp );

# Execute test
print $cmdhelp->Help();
die "1.No match" if !$cmdhelp->Matches("HELP");
die "2.No match" if !$cmdhelp->Matches("HELP ");
die "3.No match" if !$cmdhelp->Matches("HELP wibble");
die "4.Match" if $cmdhelp->Matches("wibble");

print "Wibble";
print $cmdhelp->Execute("Wibble");
print "HELP";
print $cmdhelp->Execute("HELP");
print "HELP ";
print $cmdhelp->Execute("HELP ");
print "HELP Wibble";
print $cmdhelp->Execute("HELP Wibble");
print "HELP EXIT";
print $cmdhelp->Execute("HELP EXIT");
print "HELP NEW";
print $cmdhelp->Execute("HELP NEW");
print "HELP LOAD";
print $cmdhelp->Execute("HELP LOAD");
print "HELP SAVE";
print $cmdhelp->Execute("HELP SAVE");
print "HELP RULE";
print $cmdhelp->Execute("HELP RULE");
print "HELP HELP";
print $cmdhelp->Execute("HELP HELP");

print "uCmdHelp passed.";

1;
