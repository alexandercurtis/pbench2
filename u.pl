#!/usr/bin/perl -W
# Unit tests for chatman project.

use strict;


require "uSign.pl";
require "uRuleInstance.pl";
require "uRule.pl";
require "uInterpretation.pl";
require "uRuleManager.pl";
require "uLanguageParser.pl";
require "uCmdHelp.pl";
require "uCmdLoad.pl";
require "uCmdSave.pl";
require "uCmdNew.pl";
require "uCmdRule.pl";
require "uCmdRules.pl";
require "uCmdOption.pl";
require "uCommandParser.pl";
require "uCmdExit.pl";

print "uCmdExit failed - program shouldn't get to here.\n";


1;
