package RuleManager;

use strict;

sub new
{
  my $class = shift;
  my $self = {
    m_rarRules => [],
    m_rStartingRule => undef # Top rule for top-down parsers
  };
  bless $self, $class;
  return $self;
}

sub AddRule
{
  my $self = shift;
  my $rRule = shift;
  push @{$self->{m_rarRules}}, $rRule;
  
  # The first rule that gets added becomes the starting rule
  if( !defined $self->{m_rStartingRule} )
  {
    $self->{m_rStartingRule} = $rRule;
    print "DEBUG:RuleManager.AddRule(" . $rRule->ToString() . ") New Starting Rule.\n";
  }
}

sub DeleteRules
{
  my $self = shift;
  $self->{m_rarRules} = [];
}

# Not used atm
sub SetStartingRule
{
  my $self = shift;
  $self->{m_rStartingRule} = shift;
}

sub GetStartingRule
{
  my $self = shift;
  return $self->{m_rStartingRule};
}

sub ListRules
{
  my $self = shift;
  my $str = "";
  foreach my $rRule (@{$self->{m_rarRules}})
  {
    $str .= $rRule->ToString(). "\n";
  }
  return $str;
}


1;
