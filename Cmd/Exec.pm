package Cmd::Exec;

sub new
{
  my $class = shift;
  my $parent = shift;
  my $self = {
    m_sName => "EXEC",
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
    $str .= "Executing not yet implemented.";
  }
  return $str;
}

sub Help
{
  my $self = shift;
  return "Enters the text in the given file as it if had been typed at the console.\n"
       . "NOT IMPLEMENTED.\n";
}

1;
