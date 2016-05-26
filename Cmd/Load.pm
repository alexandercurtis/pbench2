package Cmd::Load;

sub new
{
  my $class = shift;
  my $parent = shift;
  my $self = { 
    m_sName => "LOAD",
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
  if( $instruction =~ /^$self->{m_sName}\s*(.*)$/ )
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
  if( $instruction =~ /^$self->{m_sName}\s*(.*)$/ )
  {
    $str .= "Loading not yet implemented.";
  }  
  return $str;
}

sub Help
{
  my $self = shift;
  return "Loads rules and types.\n"
       . "NOT IMPLEMENTED.\n";
}

1;
