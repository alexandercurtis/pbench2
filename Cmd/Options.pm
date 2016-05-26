package Cmd::Options;

use strict;

sub new
{
  my $class = shift;
  my $parent = shift;
  my $self = {
    m_sName => "OPTIONS",
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
  if( $instruction =~ /^$self->{m_sName}\s*$/ )
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

  if( $instruction =~ /^$self->{m_sName}\s*$/ )
  {
    foreach my $option ( keys( %{$self->{m_rParent}->{m_rhOptions}} ) )
    {
      $str .= $option . " = " . $self->{m_rParent}->{m_rhOptions}->{$option} . "\n";
    }    
  }
  return $str;
}

sub Help
{
  my $self = shift;
  my $str = "";
  $str .= "Lists all currently defined options.\n";
  return $str;
}

1;

