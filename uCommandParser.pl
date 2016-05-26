#!/usr/bin/perl -W
# Unit test for CommandParser class.

use strict;

require Rule;
require Sign;
require RuleInstance;
require RuleManager;
require CommandParser;

# Set up test
my $rm = new RuleManager();
my $cp = new CommandParser( $rm );


# Execute test
die("1.Command failed.") if $cp->Execute("HELP") ne "Star commands are EXIT, HELP, NEW, LOAD, SAVE, RULE.\n";
die("2.Bad command didn't fail properly.") if $cp->Execute("Wibble Wobble") ne "Command \"WIBBLE WOBBLE\" not implemented.\n";

print "uCommandParser passed.";

1;
