package Sets;

use strict;

sub new
{
  my $class = shift;
  my $self = {
    m_raSets => []
  };
  bless $self, $class;
  return $self;
}

# Returns the n'th set, creating one if n is one more than the current number of sets.
# (Only allow for _one_ more for defensive programming reasons, because that's all the Early algorithm requires.)
sub GetSet
{
  my $self = shift;
  my $nSet = shift;
  my $nSets = scalar(@{$self->{m_raSets}});
  my $rSet;
  
  if( $nSet >= 0 && $nSet <= $nSets+1 )
  {
    if( $nSet < $nSets )
    {
      $rSet = $self->{m_raSets}->[$nSet];
    }
    else
    {    
      $rSet = [];
      push @{$self->{m_raSets}}, $rSet;
    }
  }
  return $rSet;
}



1;
