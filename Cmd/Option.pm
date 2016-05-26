package Cmd::Option;

use strict;

sub new
{
  my $class = shift;
  my $parent = shift;
  my $self = {
    m_sName => "OPTION",
    m_rParent => $parent
  };
  bless $self, $class;

  push @{$parent->{m_rarCommands}}, $self;
  return $self;
}

sub Matches
{

  my $bMatches = 0;
  my $self = shift;
  my $instruction = shift;
  if( $instruction =~ /^$self->{m_sName}\s*(.*)/ )
  {
    $bMatches = 1;
  }
  return $bMatches;
}

sub Execute
{
  my $self = shift;
  my $instruction = shift;
  my $str = "";

  if( $instruction =~ /^$self->{m_sName}\s+(.*)/ )
  {
    my $optiontext = $1;
    $optiontext =~ s/^\s+//;
    $optiontext =~ s/\s+$//;
        
    if( $optiontext =~ /^\s*(\w+)\s+(ON|OFF)\s*$/ )
    {
      $optiontext = $1;
      my $rvalue = $2;
      
      my $value = ($rvalue eq "OFF")?0:1;
      $self->{m_rParent}->{m_rhOptions}->{$optiontext} = $value;      
    }
    if( exists( $self->{m_rParent}->{m_rhOptions}->{$optiontext} ) )
    {
      $str .= $optiontext . " = " . $self->{m_rParent}->{m_rhOptions}->{$optiontext} . "\n";
    }
    else
    {
      $str .= "No value defined for \"" . $optiontext . "\".\n";
    }     
  }
  else
  {
    $str .= "Badly formed option command.\n";
  }
  return $str;
}

sub Help
{
  my $self = shift;
  my $str = "";
  $str .= "Used to specify options to the language parser.\n";
  $str .= "E.g. *OPTION PERMUTESIGNS OFF\n";
  $str .= "Can also be used to display the current setting of an option:\n";
  $str .= "E.g. *OPTION PERMUTESIGNS\n";
  $str .= "Currently supported options are: PERMUTESIGNS, PROPAGATESIGNS, FULLDISPLAY.\n";
  $str .= "Currently supported values are: ON, OFF.\n";
  return $str;
}

1;

