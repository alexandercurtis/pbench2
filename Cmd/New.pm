package Cmd::New;

sub new
{
  my $class = shift;
  my $parent = shift;
  my $self = { 
    m_sName => "NEW",
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
    $self->{m_rParent}->{m_rRulesManager}->DeleteRules();
    $str .= "All rules deleted.\n";
    $self->{m_rParent}->{m_rHintsManager}->DeleteHints();
    $str .= "All hints deleted.";    
  }  
  return $str;
}

sub Help
{
  my $self = shift;
  return "Deletes all rules.\n";
}

1;
