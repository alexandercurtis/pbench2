#!/usr/bin/perl -W
print "Parser Workbench 2!\n";
print "Enter *EXIT to exit, *HELP for help.\n";

my $rhOptions = {};
sub Debug
{
  my $s = shift;
  if( exists $rhOptions->{'DEBUG'} && $rhOptions->{'DEBUG'}>0 )
  {
    print "DEBUG: $s\n";
  }
}

use strict;



require Rule;
require Hint;
require State;
require Terminal;
require Sets;
require RuleManager;
require HintManager;
require EarleyParser;
require CommandParser;


# Read from stdin if no filename provided
my $filename = "-";
if( @ARGV > 0 )
{
  $filename = $ARGV[0];
  print "Reading from " . $filename . "\n";
}
open( FH, $filename ) or die "Can't open file.\n";

my $rRuleManager = new RuleManager();
my $rHintManager = new HintManager();
my $rLanguageParser = new EarleyParser( $rRuleManager );
my $rCommandParser = new CommandParser( $rRuleManager, $rHintManager, $rLanguageParser, $rhOptions );

while(1)
{
  while(1)
  {
    if( $filename eq "-" )
    {
      print "> ";
    }
    my $line = <FH>;
    if( !$line )
    {
      last;
    }

    chomp( $line );
    # Trim whitespace from each end.
    $line =~ s/^\s+//;
    $line =~ s/\s+$//;

    # Work in upper case
    $line = uc $line;

    # If not reading from stdin, echo the command to the screen
    if( $filename ne "-" )
    {
      print "$filename> $line\n";
    }

    if( length $line )
    {
      if( $line =~ /^\#/ )
      {
        # This is a comment. Ignore it.
      }
      elsif( $line =~ /^\*(.*)$/ )
      {
        # This is a non-natural system instruction
        print $rCommandParser->Execute($1) ."\n";
      }
      else
      {
        print $rLanguageParser->Parse($line) ."\n";
      }
    }
  }

  close FH;
  ::Debug( "main - finished reading from file.");
  # Once input file is exhausted, revert to reading from stdin
  $filename = "-";
  open( FH, $filename ) or die "Can't open file.\n";
}




