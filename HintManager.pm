package HintManager;

use strict;

sub new
{
  my $class = shift;
  my $self = {
    m_rarHints => []
  };
  bless $self, $class;
  return $self;
}

sub AddHint
{
  my $self = shift;
  my $rHint = shift;
  push @{$self->{m_rarHints}}, $rHint;
}

sub DeleteHints
{
  my $self = shift;
  $self->{m_rarHints} = [];
}


# Get all hints that match the sub-group of parts. 
# Multiply the coefficients for each hint and return the product.
sub MatchHints
{
  my $self = shift;
  my $raParts = shift;
  my $nStartPart = shift;
  my $nEndPart = shift;

  my $fProduct = 1.0;

  foreach my $rHint (@{$self->{m_rarHints}})
  {
    $fProduct *= $rHint->Match( $raParts, $nStartPart, $nEndPart );
  }

  return $fProduct;
}

sub ListHints
{
  my $self = shift;
  my $str = "";
  foreach my $rHint (@{$self->{m_rarHints}})
  {
    $str .= $rHint->ToString(). "\n";
  }
  return $str;
}


1;
