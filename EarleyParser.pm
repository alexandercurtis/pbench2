package EarleyParser;

use strict;

sub new
{
  my $class = shift;
  my $rRuleManager = shift;
  my $rSets = new Sets();

  my $self = {
    m_rRuleManager => $rRuleManager,
    m_rSets => $rSets
  };
  bless $self, $class;

  return $self;
}

# Splits a sentence string into an array of terminals.
# Private.
sub Lex
{
  my $self = shift;
  my $sTerminals = shift;
  my @asTerminals = split( /\W+/, $sTerminals);
  
  ::Debug( "EarleyParser.Lex($sTerminals) got (" . (join("+",@asTerminals)) . ")" );
  
  my @aTerminals = ();
  foreach my $sTerminal (@asTerminals)
  {
    push @aTerminals, new Terminal( $sTerminal );
  }
  
  ::Debug( "EarleyParser.Lex($sTerminals) " . scalar(@aTerminals) . " items.");
  return \@aTerminals;
}

sub Iteration
{
  my $self = shift;
  my $nWord = shift;
  my $nState = shift;
  my $rState = shift;
  my $rhAddedStates = shift;
  my $nWords = shift;
  my $raTerminals = shift;
  my $bNewStates = 0;
  ::Debug( "EarleyParser.Iteration() $nWord, $nState");


  my $raStates = $self->{m_rSets}->GetSet($nWord);

#  my $nStates = scalar(@$raStates);
  ::Debug( "EarleyParser.Parse() Inner loop state $nState of " . scalar(@$raStates));

  if( $rState->IsComplete() )
  {
    ::Debug( "Running completer on state " . $rState->{m_nId} );
    if( $self->Complete( $nWord, $rState, $raStates, $rhAddedStates ) )
    {
      $bNewStates = 1;
    }
  }
  elsif( $nWord < $nWords )
  {
    if( $self->Scan( $nWord, $rState, $raStates, $raTerminals, $rhAddedStates ) )
    {
      $bNewStates = 1;
    }
    if( $self->Predict( $nWord, $rState, $raStates, $rhAddedStates ) )
    {
      $bNewStates = 1;
    }
  }
  $rState->{m_bDone} = 1;
  return $bNewStates;
}

# The main parse function.
# Public.
sub Parse
{
  my $self = shift;
  my $sTerminals = shift;
  my $str = "\n";

  # Clear any sets from previous parse
  $self->{m_rSets} = new Sets();
  
  ::Debug( "EarleyParser.Parse( $sTerminals )");
  
  # Add starting rule to set 0.
  my $raFirstSet = $self->{m_rSets}->GetSet(0);
  my $rStartingRule = $self->{m_rRuleManager}->GetStartingRule();
  # Assert rStartingRule!
  push @$raFirstSet, new State( $rStartingRule, 0, 0, 0, 1.0 );
  ::Debug( "EarleyParser.Parse() Starting rule is " . $rStartingRule->ToString());

  
  # Split sentence into an array of terminals
  my $raTerminals = $self->Lex( $sTerminals );
  my $nWords = scalar(@$raTerminals);
  my $bAtLeastOneSuccessfulParse = 0;
  
  # Keep track of which states have been added
  my $rahAddedStates = [];
  
  my $bNoStatesLeft = 0;
  
  do
  {
    my $nBestWord = -1;
    my $nBestState = -1;
    my $rBestState = undef;
    my $nBestProb = -1;
    $bNoStatesLeft = 1;

    ::Debug( "EarleyParser.Parse() Do.");
    
    # Find next state to iterate
    for( my $nWord=0; $nWord < $nWords+1; ++$nWord )
    {
      my $raStates = $self->{m_rSets}->GetSet($nWord);
      my $nStates = scalar(@$raStates);
      for( my $nState = 0; $nState < $nStates; ++$nState )
      {
        my $rState = $raStates->[$nState];
        if( $rState->{m_bDone} != 1 )
        {
          $bNoStatesLeft = 0;
          my $nProb = $rState->{m_nProb};
          ::Debug( "EarleyParser.Parse() Testing Word $nWord / $nWords State $nState / $nStates Prob $nProb vs $nBestProb.");
          
          if( $nProb > $nBestProb )
          {
            ::Debug( "EarleyParser.Parse() Better.");
            $nBestState = $nState;
            $rBestState = $rState;
            $nBestWord = $nWord;
            $nBestProb = $nProb;
          }
        }
      }      
    }
    if( $nBestWord >=0 && $nBestState >= 0 && defined $rBestState )
    {
      ::Debug( "EarleyParser.Parse() Best Word $nBestWord State $nBestState Prob $nBestProb.");
      
      if( !exists $rahAddedStates->[$nBestWord] )
      {
        $rahAddedStates->[$nBestWord] = {};
      }

      my $sDottedTerminals = "";
      my $nDottedTerminal = 0;
      foreach my $rDottedTerminal (@$raTerminals)
      {
        if( $nDottedTerminal == $nBestWord )
        {
          $sDottedTerminals .= ".";
          ++$nDottedTerminal;
        }
        if( $nDottedTerminal > 0 )
        {
          $sDottedTerminals .= " ";
        }
        $sDottedTerminals .= $rDottedTerminal->ToString();
        ++$nDottedTerminal;
      }
      print "STATE: == S($nBestWord): $sDottedTerminals ==\n";      
      
      if( $self->Iteration( $nBestWord, $nBestState, $rBestState, $rahAddedStates->[$nBestWord], $nWords, $raTerminals ) )
      {
        $bNoStatesLeft = 0;
      }
      if( $nBestWord == $nWords )
      {
        if( $rBestState->IsComplete() )
        {
          if( $rBestState->{m_rRule}->LHSMatches( $rStartingRule->GetName() ) )
          {
            $bAtLeastOneSuccessfulParse = 1;
            # Can break out at this point if only care about getting a parse.
          }
        }
      }      
    }
  }
  while(!$bNoStatesLeft);
  
  
  
  ::Debug( "EarleyParser.Parse() Finished parsing.");
  if( $bAtLeastOneSuccessfulParse )
  {
    ::Debug( "EarleyParser.Parse() Complete.");
  }

  
  # Output complete parse states
  my $nSet = 0;
  foreach my $raSet (@{$self->{m_rSets}->{m_raSets}})
  {
    ::Debug( "EarleyParser.Parse() Output testing set ".($nSet).".");
    foreach my $rState (@$raSet)
    {
      ::Debug( "EarleyParser.Parse() Output testing state ".($rState->ToString()).".");
      ::Debug( "EarleyParser.Parse() Starting rule=". ($rStartingRule->GetName() eq $rState->{m_rRule}->GetName()) .".");
      ::Debug( "EarleyParser.Parse() Complete=". $rState->IsComplete() .".");
      ::Debug( "EarleyParser.Parse() Start Set=". ($rState->{m_nStartPos} == 0) .".");
      
      if( ($rStartingRule->GetName() eq $rState->{m_rRule}->GetName()) 
       && $rState->IsComplete()
       && $rState->{m_nStartPos} == 0 )
      {
        
        if( $nSet == $nWords )
        {
          ::Debug( "EarleyParser.Parse() State ". $rState->Dump() . " is a complete parse.");
          $str .= $rState->ToParseTree() . "\n";
        }
        else
        {
          ::Debug( "EarleyParser.Parse() State ". $rState->Dump() . " is a partial parse.");          
        }
      }
    }
    ++$nSet;
  }
  
  ::Debug( "EarleyParser.Parse() Return $str");

  return $str;
}

# Private
sub Predict
{
  my $self = shift;
  my $nSet = shift;
  my $rState = shift;
  my $raCurrentSet = shift;
  my $rhAddedStates = shift;
  
  ::Debug( "EarleyParser.Predict($nSet)");
  
  my $nPredictions = 0;

  my $sSymbolName = $rState->GetCurrentSymbolName();
  if( defined $sSymbolName )
  {
    ::Debug( "EarleyParser.Predict() Testing symbol $sSymbolName");
    
    foreach my $rRule (@{$self->{m_rRuleManager}->{m_rarRules}})
    {
      ::Debug( "EarleyParser.Predict() Testing rule ". $rRule->ToString());
      if( $rRule->LHSMatches( $sSymbolName ) )
      {
        ::Debug( "EarleyParser.Predict() Rule matches.");
    
        my $rNewState = new State( $rRule, 0, $nSet, scalar(@$raCurrentSet), $rState->{m_nProb} * $rRule->{m_nProb} );
        if( !exists( $rhAddedStates->{$rNewState->GetHashKey()} ) )
        { 
          $rhAddedStates->{$rNewState->GetHashKey()} = 1;       
          push @$raCurrentSet, $rNewState;
          my $nState = $rState->{m_nState} + 1;
          ::Debug( "EarleyParser.Predict() new state ". $rNewState->ToString() ." added to set". $nSet ." from state " . $nState. ".");

          $rNewState->{d_sComment} = "predict from (" . ($nState) .")";
          print "STATE: " . $rNewState->Dump() . "\n";
          
          ++$nPredictions;
        }
        else
        {        
          ::Debug( "EarleyParser.Predict() new state ". $rNewState->ToString() ." repeated.");
        }
      }
    }
  }

  
  return $nPredictions;
}

# Private
sub Scan
{
  my $self = shift;
  my $nSet = shift;  
  my $rState = shift;
  my $raCurrentSet = shift;  
  my $raTerminals = shift;
  my $rhAddedStates = shift;  
  my $raNextSet = $self->{m_rSets}->GetSet($nSet+1);
  my $nScans = 0;
  
  ::Debug( "EarleyParser.Scan($nSet)");
  ::Debug( "EarleyParser.Scan() Testing terminal against state ".$rState->ToString());

  my $rTerminal = $raTerminals->[$nSet];
  if( $rState->Matches( $rTerminal ) )
  {
    ::Debug( "EarleyParser.Scan() Match");
    
    my $rNewState = new State( $rState->{m_rRule}, $rState->{m_nCurrentPos} + 1, $rState->{m_nStartPos}, scalar(@$raNextSet), $rState->{m_nProb} );
    push(@{$rNewState->{m_raConstituents}}, @{$rState->{m_raConstituents}});
        
    if( !exists( $rhAddedStates->{$rNewState->GetHashKey()} ) )
    {        
      $rhAddedStates->{$rNewState->GetHashKey()} = 1;                 
      push @$raNextSet, $rNewState;
      my $nState = $rState->{m_nState} + 1;
      
      ::Debug( "EarleyParser.Scan() new state ". $rNewState->ToString() ." added to set". ($nSet+1) ." from state ".($nState) .".");
      
      $rNewState->{d_sComment} = "scan from S(" . ($nSet) .")(" . ($nState) . ")";
      print "STATE: " . $rNewState->Dump() . "\n";
      ++$nScans;
    }
    else
    {
      ::Debug( "EarleyParser.Scan() new state ". $rNewState->ToString() ." repeated.");
    }
  }

  
  return $nScans;
}

# Private
sub Complete
{
  my $self = shift;
  my $nSet = shift;    
  my $rState = shift;
  my $raCurrentSet = shift;    
  my $rhAddedStates = shift;
  my $nCompletions = 0;
  
  ::Debug( "EarleyParser.Complete($nSet)");
  

  ::Debug( "EarleyParser.Complete() State ". $rState->ToString() ." is complete.");
  
  my $nPreviousSet = $rState->{m_nStartPos};
  my $raPreviousSet = $self->{m_rSets}->GetSet($nPreviousSet);
  my $nPreviousState = 0;
  foreach my $rPreviousState (@$raPreviousSet)
  {
    ::Debug( "EarleyParser.Complete() testing previous state ". $rPreviousState->ToString());

    if( $rPreviousState->Matches( $rState->{m_rRule} ) )
    {          
      my $nMatchPos = $rPreviousState->{m_nCurrentPos};
      ::Debug( "EarleyParser.Complete() matches at $nMatchPos");
      
      my $rNewState = new State( $rPreviousState->{m_rRule}, $nMatchPos+1, $rPreviousState->{m_nStartPos}, scalar(@$raCurrentSet), $rPreviousState->{m_nProb} );
      push(@{$rNewState->{m_raConstituents}}, @{$rPreviousState->{m_raConstituents}});
      push @{$rNewState->{m_raConstituents}},  $rState;
      if( !exists( $rhAddedStates->{$rNewState->GetHashKey()} ) )
      {
        $rhAddedStates->{$rNewState->GetHashKey()} = 1;                   

        ::Debug( "EarleyParser.Complete() Previous state ". $rPreviousState->{m_nId} ." has new constituent ". $rState->{m_nId} ." giving " . $rPreviousState->GetConstituents());
        ::Debug( "EarleyParser.Complete() New state constituents ". $rNewState->GetConstituents());
                
        push @$raCurrentSet, $rNewState;
        my $nState = $rState->{m_nState} + 1;
        
        ::Debug( "EarleyParser.Complete() new state ". $rNewState->ToString() ." added to set $nSet from state ".($nState).".");

        $rNewState->{d_sComment} = "complete from S(" . ($nPreviousSet) .")(" . ($nPreviousState+1) . ")";
        print "STATE: " . $rNewState->Dump() . "\n";
        ++$nCompletions;
      }
      else
      {
        ::Debug( "EarleyParser.Complete() new state ". $rNewState->ToString() ." repeated.");
      }
      
    }  
    ++$nPreviousState;      
  }
  
  return $nCompletions;
}


  
1;
