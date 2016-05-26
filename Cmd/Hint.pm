package Cmd::Hint;

sub new
{
  my $class = shift;
  my $parent = shift;
  my $self = {
    m_sName => "HINT",
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
  if( $instruction =~ /^$self->{m_sName}\s*(.*)/ )
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
  my $bRejectHint = 0;

  if( $instruction =~ /^$self->{m_sName}\s+(.*)/ )
  {
    my $hinttext = $1;
    if( $hinttext =~ /^\s*([\w\+\{\} \?]+)\s*=\s*([\d\.]+)\s*$/ )
    {
      my $lvalue = $1;
      my $rvalue = $2;

      # Trim whitespace from each end.
      $rvalue =~ s/^\s+//;
      $rvalue =~ s/\s+$//;
      # Check no { or } anywhere in it.
      if( ($rvalue*1.0) != $rvalue )
      {
        $str .= "Bad coefficient " . $rvalue ."\n";
        $bRejectHint = 1;
      }
      
      if( !$bRejectHint )
      {
        my @lvalues = split /\+/, $lvalue;
        my @oklvalues = ();
        foreach my $alvalue (@lvalues)
        {
          my $olvalue = $alvalue;
          # Trim whitespace from each end.
          $alvalue =~ s/^\s+//;
          $alvalue =~ s/\s+$//;
          if( length $alvalue > 0 )
          {
            if( substr($alvalue, 0, 1) eq "{" )
            {
              # String starts with {. Check it ends with }.
              if( substr($alvalue, -1, 1) ne "}" )
              {
                $str .= "Badly formed sign(1) " . $olvalue ."\n";
                $bRejectHint = 1;
                last;
              }
              else
              {
                # String is enclosed in {} so check for any { or } inside the string.
                if( length( $alvalue ) == 2 )
                {
                  $str .= "Empty sign(1) " . $olvalue ."\n";
                  $bRejectHint = 1;
                  last;
                }
                elsif( index( $alvalue, "{", 1 ) != -1 )
                {
                  $str .= "Badly formed sign(2) ".index( $alvalue, "{", 1 ).",".length( $alvalue ).":" . $olvalue ."\n";
                  $bRejectHint = 1;
                  last;
                }
                elsif( index( $alvalue, "}", 1 ) != length( $alvalue ) - 1 )
                {
                  $str .= "Badly formed sign(3) " . $olvalue ."\n";
                  $bRejectHint = 1;
                  last;
                }
              }
            }
            else
            {
              # String doesn't start with {, so check no { or } anywhere in it.
              if( index( $alvalue, "{" ) != - 1 )
              {
                $str .= "Badly formed part(1) " . $olvalue ."\n";
                $bRejectHint = 1;
                last;
              }
              elsif( index( $alvalue, "}" ) != - 1 )
              {
                $str .= "Badly formed part(2) " . $olvalue ."\n";
                $bRejectHint = 1;
                last;
              }
            }
            if( length $alvalue )
            {
              push @oklvalues, $alvalue;
            }
          }
        }
        if( !$bRejectHint )
        {
          my $rHint = new Hint( $rvalue, \@oklvalues );
          $self->{m_rParent}->{m_rHintsManager}->AddHint( $rHint );
          $str .= $rHint->ToString();
          $str .= "\n";
        }
      }
    }
    else
    {
      $str .= "Bad hint syntax \"$1\"";
    }
  }
  else
  {
    $str .= "No hint made.\n";
  }
  return $str;
}

sub Help
{
  my $self = shift;
  my $str = "";
  $str .= "Defines a new hint. Use ? as a wildcard to match any part.\n";
  $str .= "e.g. *HINT NP+NP+NP=0.5\n";
  $str .= "e.g. *HINT ?+SENTENCE=0.0\n";
  return $str;
}

1;

