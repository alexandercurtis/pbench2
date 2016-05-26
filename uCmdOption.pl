#!/usr/bin/perl -W
# Unit test for Cmd::Option class.

use strict;

require Rule;
require Sign;
require RuleInstance;
require RuleManager;
require CommandParser;

# Set up test
my $rm = new RuleManager();
my $cp = new CommandParser( $rm );
my $cmdoption = new Cmd::Option( $cp );


# Execute test
print $cmdoption->Help();
print $cmdoption->Execute("wibble");
print $cmdoption->Execute("OPTION PERM OFF");
print $cmdoption->Execute("OPTION PERM");
print $cmdoption->Execute("OPTION PERM ON");
print $cmdoption->Execute("OPTION PERM");
print $cmdoption->Execute("OPTION wibble ON");
print $cmdoption->Execute("OPTION wibble");

print "uCmdOption passed.";

1;
