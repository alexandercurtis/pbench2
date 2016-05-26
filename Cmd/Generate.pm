package Cmd::Generate;

sub new
{
  my $class = shift;
  my $parent = shift;
  my $self = {
    m_sName => "GENERATE",
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
    $str .= $self->{m_rParent}->{m_rLanguageParser}->Generate( $1 );
  }
  return $str;
}

sub Help
{
  my $self = shift;
  return "Generates random strings using the current rules.\n"
       . "NOT IMPLEMENTED.\n";
}

1;
