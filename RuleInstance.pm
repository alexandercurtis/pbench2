package RuleInstance;

use strict;

# Include this if parent class Part becomes anything: our @ISA = qw(Part);

sub new
{
  my $class = shift;
  my $self = {
    m_rRule => shift,
    m_rarParts => shift
  };
  bless $self, $class;
  return $self;
}

sub GetName
{
  my $self = shift;
  return $self->{m_rRule}->GetName();
}

sub ToString
{
  my $self = shift;

  my $str = "";
  my $isJustOneSign = -1;
  foreach my $rPart (@{$self->{m_rarParts}})
  {
    if( length $str > 0 )
    {
      $str .= " ";
    }
    $str .= $rPart->ToString();

    if( $isJustOneSign == -1 && $rPart->isa("Sign") )
    {
      $isJustOneSign = 1;
    }
    else
    {
      $isJustOneSign = 0;
    }
  }
  if( $isJustOneSign==0 )
  {
    $str = "[ " . $str . " ]";
  }
  return $self->GetName().$str;
}

sub ToShortString
{
  my $self = shift;
  return $self->GetName();
}

sub ToSenseString
{
  my $self = shift;
  my $bTopLevel = shift;

  my $str = "";
  foreach my $rPart (@{$self->{m_rarParts}})
  {
    if( length $str > 0 )
    {
      $str .= " ";
    }
    $str .= $rPart->ToSenseString(0);
  }
  if( $bTopLevel )
  {
    return $self->GetName()."[ " . $str . " ]";
  }
  else
  {
    return $str;
  }
}

1;
