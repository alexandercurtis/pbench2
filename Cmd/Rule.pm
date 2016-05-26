package Cmd::Rule;

sub new
{
  my $class = shift;
  my $parent = shift;
  my $self = {
    m_sName => "RULE",
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
  my $bRejectRule = 0;

  if( $instruction =~ /^$self->{m_sName}\s+(.*)/ )
  {
    my $ruletext = $1;
    $ruletext =~ s/->/=/;
    if( $ruletext =~ /^\s*(\w+)\s*=\s*([\w\'\+\{\} \|]+)(\s+([0-9\.]+))?\s*$/ )
    {
      my $lvalue = $1;
      my @rvalues = split(/\|/,$2);
      my $nProb = $4;
      if( !defined $nProb )
      {
        $nProb = 1.0;
      }
      foreach my $rvalue (@rvalues)
      {
        # Trim whitespace from each end.
        $lvalue =~ s/^\s+//;
        $lvalue =~ s/\s+$//;
        # Check no { or } anywhere in it.
        if( index( $lvalue, "{" ) != - 1 )
        {
          $str .= "Badly formed name " . $lvalue ."\n";
          $bRejectRule = 1;
        }
        elsif( index( $lvalue, "}" ) != - 1 )
        {
          $str .= "Badly formed name " . $lvalue ."\n";
          $bRejectRule = 1;
        }

        if( !$bRejectRule )
        {
          my @rvalues = split /\+/, $rvalue;
          my @okrvalues = ();
          foreach my $arvalue (@rvalues)
          {
            my $orvalue = $arvalue;
            # Trim whitespace from each end.
            $arvalue =~ s/^\s+//;
            $arvalue =~ s/\s+$//;
            if( length $arvalue > 0 )
            {
              if( substr($arvalue, 0, 1) eq "{" )
              {
                # String starts with {. Check it ends with }.
                if( substr($arvalue, -1, 1) ne "}" )
                {
                  $str .= "Badly formed sign(1) " . $orvalue ."\n";
                  $bRejectRule = 1;
                  last;
                }
                else
                {
                  # String is enclosed in {} so check for any { or } inside the string.
                  if( length( $arvalue ) == 2 )
                  {
                    $str .= "Empty sign(1) " . $orvalue ."\n";
                    $bRejectRule = 1;
                    last;
                  }
                  elsif( index( $arvalue, "{", 1 ) != -1 )
                  {
                    $str .= "Badly formed sign(2) ".index( $arvalue, "{", 1 ).",".length( $arvalue ).":" . $orvalue ."\n";
                    $bRejectRule = 1;
                    last;
                  }
                  elsif( index( $arvalue, "}", 1 ) != length( $arvalue ) - 1 )
                  {
                    $str .= "Badly formed sign(3) " . $orvalue ."\n";
                    $bRejectRule = 1;
                    last;
                  }
                }
              }
              else
              {
                # String doesn't start with {, so check no { or } anywhere in it.
                if( index( $arvalue, "{" ) != - 1 )
                {
                  $str .= "Badly formed part(1) " . $orvalue ."\n";
                  $bRejectRule = 1;
                  last;
                }
                elsif( index( $arvalue, "}" ) != - 1 )
                {
                  $str .= "Badly formed part(2) " . $orvalue ."\n";
                  $bRejectRule = 1;
                  last;
                }
              }
              if( length $arvalue )
              {
                push @okrvalues, $arvalue;
              }
            }
          }
          if( !$bRejectRule )
          {
            my $rRule = new Rule( $lvalue, \@okrvalues, $nProb );
            $self->{m_rParent}->{m_rRulesManager}->AddRule( $rRule );
            $str .= $rRule->ToString();
            $str .= "\n";
          }
        }
      }
    }
    else
    {
      $str .= "Bad rule syntax \"$1\"";
    }
  }
  else
  {
    $str .= "No rule made.\n";
  }
  return $str;
}

sub Help
{
  my $self = shift;
  my $str = "";
  $str .= "Defines a new rule.\n";
  $str .= "e.g. *RULE NOUN -> {cat}\n";
  $str .= "e.g. *RULE NOUN -> {dog}\n";
  $str .= "e.g. *RULE NP -> DET+NOUN\n";
  $str .= "e.g. *RULE NP -> DET+NOUN 0.8 (Probabilistic rule)\n";
  $str .= "e.g. *RULE NOMINAL -> NOUN | NOMINALNOUN   (Generates two rules)\n";
  $str .= "Note that '=' can be used instead of '->'. \n";
  return $str;
}

1;

