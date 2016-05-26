#!/usr/bin/perl -W
# Unit test for Cmd::Load class.

use strict;

require CommandParser;

# Set up test
my $cp = new CommandParser();
my $cmdload = new Cmd::Load( $cp );

# Execute test
print $cmdload->Help();
die "1.No match" if !$cmdload->Matches("LOAD");
die "2.No match" if !$cmdload->Matches("LOAD ");
die "3.No match" if !$cmdload->Matches("LOAD wibble");
die "4.Match" if $cmdload->Matches("wibble");
print $cmdload->Execute("Wibble");
print $cmdload->Execute("LOAD");
print $cmdload->Execute("LOAD ");
print $cmdload->Execute("LOAD X");

print "uCmdLoad passed.";


1;
