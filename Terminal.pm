package Terminal;

use strict;

our %hTerminals = ();
# Include this if parent class Part becomes anything: our @ISA = qw(Part);

sub new
{
  my $class = shift;
  my $self = {
    m_sText => shift
  };
  bless $self, $class;
  return $self;
}

# Returns the text of this terminal.
sub GetName()
{
  my $self = shift;
  return $self->ToString();
}

# Returns the this sign in text form.
sub ToString()
{
  my $self = shift;
  return "{$self->{m_sText}}";
}

1;

