use strict;

require Cmd::Exit;
require Cmd::Help;
require Cmd::New;
require Cmd::Load;
require Cmd::Save;
require Cmd::Rules;
require Cmd::Rule;
require Cmd::Options;
require Cmd::Option;
require Cmd::Hints;
require Cmd::Hint;
require Cmd::Exec;
require Cmd::Generate;

package CommandParser;

sub new
{
  my $class = shift;
  my $self = {
    m_rRulesManager => shift,
    m_rHintsManager => shift,
    m_rLanguageParser => shift,
    m_rarCommands => [],
    m_rhOptions => shift
  };

  bless $self, $class;

  new Cmd::Exit( $self );
  new Cmd::Help( $self );
  new Cmd::New( $self );
  new Cmd::Load( $self );
  new Cmd::Save( $self );
  new Cmd::Rules( $self );
  new Cmd::Rule( $self );
  new Cmd::Options( $self );
  new Cmd::Option( $self );
  new Cmd::Hints( $self );
  new Cmd::Hint( $self );
  new Cmd::Exec( $self );
  new Cmd::Generate( $self );

  return $self;
}

sub Execute
{
  my $self = shift;
  my $instruction = uc shift;

  my $parseok = 0;
  my $str = "";

  foreach my $rCmd (@{$self->{m_rarCommands}})
  {
    if( $rCmd->Matches($instruction) )
    {
      $str .= $rCmd->Execute($instruction);
      $parseok = 1;
      last;
    }
  }
  if( !$parseok )
  {
    $str .= "Command \"" . $instruction . "\" not implemented.\n";
  }
  return $str;
}



1;
