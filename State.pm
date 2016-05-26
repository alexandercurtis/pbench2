package State;

use strict;
my $nUniqueId = 0;

sub new
{
  my $class = shift;
  my $self = {
    m_rRule => shift,
    m_nCurrentPos => shift,
    m_nStartPos => shift,
    m_nState => shift,
    m_raConstituents => [],
    m_nId => $nUniqueId,
    m_bDone => 0,
    m_nProb => shift
  };
  bless $self, $class;
  ++$nUniqueId;
  return $self;
}

sub ToString
{
  my $self = shift;
  my $str .= $self->{m_rRule}->ToDottedString( $self->{m_nCurrentPos} ) . "\t\t(" . $self->{m_nStartPos} .")";  
  return $str;
}

sub GetHashKey
{
  my $self = shift;
  my $str .= $self->{m_rRule}->ToString() . "," . $self->{m_nCurrentPos};  
  
  foreach my $rConstituent (@{$self->{m_raConstituents}})
  {
    $str .= "," . $rConstituent->{m_nId};
  }  
  
  return $str;
}

sub Matches
{
  my $self = shift;
  my $rSymbol = shift;
  
  my $sSymbol = $rSymbol->GetName();
  return( $self->{m_rRule}->RHSPartMatches( $self->{m_nCurrentPos}, $sSymbol ) );
}

sub GetCurrentSymbolName
{
  my $self = shift;
  my $sSymbol = $self->{m_rRule}->GetRHSAt( $self->{m_nCurrentPos} );  
  return $sSymbol;
}

sub IsComplete
{
  my $self = shift;
  my $nParts = $self->{m_rRule}->GetNumRHSParts();
  return( $self->{m_nCurrentPos} >= $nParts );
}

sub GetConstituents
{
  my $self = shift;
  my $str = "";
  
  $str .= $self->{m_nId};
  if( scalar(@{$self->{m_raConstituents}}) > 0 )
  {
    $str .= "(";
    my $nConstituent = 0;
    foreach my $rConstituent (@{$self->{m_raConstituents}})
    {
      if( $nConstituent > 0 )
      {
        $str .= " ";
      }
      $str .= $rConstituent->GetConstituents();
      ++$nConstituent;
    }
    $str .= ")";
  }
  return $str;
}

# Debug output
sub Dump
{
  my $self = shift;
  
  my $str = $self->{m_nId} .":(" . ($self->{m_nState}+1) . ")  " . $self->ToString() . " \t\t# " . $self->{d_sComment} . "  C:" . $self->GetConstituents(). "";
  return $str;
}

sub ToParseTree
{
  my $self = shift;
  my $str = "";
  
  $str .= $self->{m_rRule}->GetName();
  if( scalar(@{$self->{m_raConstituents}}) > 0 )
  {
    $str .= "(";
    my $nConstituent = 0;
    foreach my $rConstituent (@{$self->{m_raConstituents}})
    {
      if( $nConstituent > 0 )
      {
        $str .= " ";
      }
      $str .= $rConstituent->ToParseTree();
      ++$nConstituent;
    }
    $str .= ")";
  }
  return $str;
}

1;
