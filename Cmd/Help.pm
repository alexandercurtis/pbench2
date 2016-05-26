package Cmd::Help;

sub new
{
  my $class = shift;
  my $parent = shift;
  my $self = {
    m_sName => "HELP",
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
    if( $1 )
    {
      my $bFound = 0;
      foreach my $rCmd (@{$self->{m_rParent}->{m_rarCommands}})
      {
        if( $rCmd->Matches($1) )
        {
          $str .= "$rCmd->{m_sName}:\n";
          $str .= $rCmd->Help();
          $bFound = 1;
          last;
        }
      }
      if( !$bFound )
      {
        $str .= "Command \"" . $1 . "\" is not available.\n";
      }
    }
    else
    {
      $str .= "Star commands are ";
      my $bFirst = 1;
      foreach my $rCmd (@{$self->{m_rParent}->{m_rarCommands}})
      {
        if( $bFirst )
        {
          $bFirst = 0;
        }
        else
        {
          $str .= ", ";
        }
        $str .= $rCmd->{m_sName};
      }
      $str .= ".\n";
    }
  }
  return $str;
}

sub Help
{
  my $self = shift;
  return "Displays a list of possible commands.\n"
       . "HELP <cmd> gives help on the specified command.\n";
}

1;
