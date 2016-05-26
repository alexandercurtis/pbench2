package Hint;

use strict;

sub new
{
  my $class = shift;
  my $self = {
    m_fCoefficient => shift,  # How much this hint adjusts the outcome.
    m_rasPartNames => shift  # undef, or array of names of parts, in sequence required for this hint to match.
  };
  bless $self, $class;
  return $self;
}

sub GetCoefficient
{
  my $self = shift;
  return $self->{m_fCoefficient};
}

# Returns the hint's coefficient if it matches the parts given.
sub Match
{
  my $self = shift;
  my $rarParts = shift;
  my $nStartPart = shift; # start index (inclusive)
  my $nEndPart = shift; # finish index (exclusive)
  my $rInstance = undef;
  my $bMatched = 1;
  my $fCoefficient = 1.0; # Default coefficient value of 1 to leave weight of the interpretation unchanged.
  
  # Initial check that number of parts are the same
  if( $nEndPart-$nStartPart == scalar (@{$self->{m_rasPartNames}}) )
  {
    my $n = $nStartPart;
    # Check that each part matches
    foreach my $sPartName ( @{$self->{m_rasPartNames}} )
    {
      if( ($sPartName ne "?") && ($sPartName ne $rarParts->[$n]->GetName()) )
      {
        # Some part(s) didn't match
        $bMatched = 0;
        last;
      }
      ++$n;
    }
    if( $bMatched )
    {
      # All parts matched
      $fCoefficient = $self->GetCoefficient();
    }
  }
  return $fCoefficient;
}

sub ToString
{ 
  my $self = shift;
  my $str = "";
  
  my $bFirst = 1;
  foreach my $sPart (@{$self->{m_rasPartNames}})
  {
    if( $bFirst )
    {
      $bFirst = 0;
    }
    else
    {
      $str .= " + ";
    }
    $str .= $sPart;
  }  
  $str .= " = " . $self->GetCoefficient();  
  return $str;
}

1;
