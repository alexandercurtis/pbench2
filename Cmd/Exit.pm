package Cmd::Exit;

sub new
{
  my $class = shift;
  my $parent = shift;
  my $self = { 
    m_sName => "EXIT",
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
  if( $self->Matches($instruction) )
  {
    exit 0;
  }
  return "";  
}

sub Help
{
  my $self = shift;
  return "Exits this program.\n";
}

1;
