package Rule;

use strict;

sub new
{
  my $class = shift;
  my $self = {
    m_sName => shift,      
    m_rasPartNames => shift, 
    m_nProb => shift 
  };
  bless $self, $class;
  return $self;
}

sub GetName
{
  my $self = shift;
  return $self->{m_sName};
}

sub LHSMatches
{
  my $self = shift;
  my $sSymbolName = shift;
  
  my $bRet = $self->GetName() eq $sSymbolName;
  return $bRet;
}

sub RHSPartMatches
{
  my $self = shift;
  my $nPos = shift;
  my $sSymbol = shift;
  
  my $sPartName = $self->GetRHSAt( $nPos );
  if( defined $sPartName )
  {
    ::Debug( "Rule.RHSPartMatches() Testing $sPartName against $sSymbol");
  }
  else
  {
    ::Debug( "Rule.RHSPartMatches() match end.");
    return 0;
  }
  
  return( $sSymbol eq $sPartName );
}

sub GetRHSAt
{
  my $self = shift;
  my $nPos = shift;
  
  my $sPartName;
  my $nPartNames = $self->GetNumRHSParts();
  if( $nPos >= 0 && $nPos < $nPartNames )
  {
    $sPartName = $self->{m_rasPartNames}[$nPos];
  }
  return $sPartName;
}

sub GetNumRHSParts
{
  my $self = shift;
  return scalar( @{$self->{m_rasPartNames}} );
}

sub ToString
{
  my $self = shift;
  my $str = "";

  $str .= $self->GetName() . " -> ";
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
  $str .= " (" . $self->{m_nProb} . ")";
  return $str;
}

sub ToDottedString
{
  my $self = shift;
  my $nDot = shift;
  my $str = "";

  $str .= $self->GetName() . " -> ";
  my $nPart = 0;
  foreach my $sPart (@{$self->{m_rasPartNames}})
  {
    if( $nPart == $nDot )
    {
      $str .= ".";
      ++$nPart;
    }
    if( $nPart>0 )
    {
      $str .= " ";
    }
    $str .= $sPart;
    ++$nPart;
  }
  if( $nPart == $nDot )
  {
    $str .= ".";
  }
  return $str;
}

1;
