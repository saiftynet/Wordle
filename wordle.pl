#!/usr/env perl
use strict;use warnings;

BEGIN {  # attempt to get this to work on Windows Consoles
   if ($^O eq 'MSWin32') {
	 require  'Win32\Console\ANSI.pm';
   }
   Win32::Console::ANSI->import;
}
use Term::ANSIColor;  # allow coloured terminal output

my $wordLength=5;     # set number of letters 
my $maxGuesses=6;     # set number of guesses 
my (@guesses, %guessedChars,$goes, $gotIt, $guess,%workspace,@keyboard);
my $firstLoad=1;      
my %scores=(wins=>0,fails=>0);
$scores{$_}=0 foreach (1..$maxGuesses);

# load the valid words from Unix Dictionary
my %validWords=();
open my $fh, "<", "/usr/share/dict/words"; 
foreach my $word (<$fh>){
	chomp $word;
	$validWords{uc($word)}=1 if ($word=~m/^[a-z]{$wordLength}$/)
}
close $fh;

#main game loop
while ($firstLoad || prompt("\nWant another game Y/N?")=~/^y/i){
	$firstLoad=0;
	%guessedChars=();
	@guesses=("|"."   |"x$wordLength)x$maxGuesses;
	$guess=""; $goes=0; $gotIt=0;
	$workspace{gotIt}=0;
	@keyboard=("    Q  W  E  R  T  Y  U  I  O  P ",
              "      A  S  D  F  G  H  J  K  L ",
              "        Z  X  C  V  B  N  M ",);
	my $answer=(keys %validWords)[ rand keys %validWords ];
		
	while (!$workspace{gotIt} && $goes++ < $maxGuesses){
		drawTable();
		while ($guess eq "" || notValid($guess)){
			$guess=uc(prompt("Guess $goes >>"));
		}
		$validWords{$guess}=2;
		updateKeyboard($guess,$answer);
		match($guess,$answer);               # check for match
		$guesses[$goes-1]=$workspace{show};  # populate row
		$guess="";                           # reset guess
	}

	if ($workspace{gotIt}){ 
		drawTable();
		print "\nWell done!! Guessed it in $goes\nScore:- ";
		$scores{wins}++;$scores{$goes}++;
	}
	else{
		drawTable();
		print "Failed!! answer was $answer\nScore:- ";
		$scores{fails}++
	}
	print " $_=$scores{$_} ;" foreach (sort keys %scores);
}

sub drawTable{
	system $^O eq 'MSWin32' ? 'cls':'clear';
	print color("blue")."                W O R D L E\n".color("reset");
	my $rowseparator="          +".("---+" x $wordLength)."\n";
	my $line=0;
	foreach my $row(@guesses){
		print $rowseparator;
		print "          $row";
		$line ++;
		print $keyboard[$line-2] if ($line>=2  && $line<5); 
		print"\n";
	}
	print $rowseparator;
}

sub match{
	my ($guess,$answer)=@_;
	%workspace=();
	my @colours=(color("white"),color("green"),color("yellow"));
	$workspace{gotIt}=(uc($guess) eq uc($answer))?1:0;
	$workspace{guess}=[split (//,uc($guess))];
	$workspace{answer}=[split (//,uc($answer))];
	$workspace{match}=[map {$workspace{guess}[$_ ] eq $workspace{answer}[$_ ]?1:0} (0..($wordLength-1)) ]; 
	$workspace{match}=[map {$workspace{match}[$_ ]==1? $workspace{match}[$_ ]:($answer=~/$workspace{guess}[$_ ]/i?2:0) } (0..($wordLength-1)) ];
	$workspace{show} ="| ".join (" | ",map {
		       $colours[$workspace{match}[$_ ]].
		       $workspace{guess}[$_ ].color("reset");
		       }  (0..($wordLength-1)))." |";
}

sub updateKeyboard{
	my ($guess,$answer)=@_;
	$guess=uc($guess);
	foreach my $gc(split (//,$guess)){
	    my $c=($answer=~/$gc/)?color("cyan"):color("red");
	    my $r=color("reset");
		foreach my $kbRow (0..2){
			$keyboard[$kbRow]=~s/ $gc / $c$gc$r /;
		}
	}
}

sub prompt{ 
	my $pr=shift;
	print color('bold yellow'),$pr,">>";
	print color('bold green');
	chomp(my $response=<STDIN>);
	print color('reset');
	return $response;
}

sub notValid{
	my $word=shift;
	return 1 if $word eq "";
	if (length $word != $wordLength){
		print color('bold red')."Word must have $wordLength letters, pal!\n", color('reset');
		return 1;
	}
	elsif (! exists $validWords{$word}){
		print color('bold red'),"You crazy? That word does not exist!\n", color('reset');
		return 1;
	}
	elsif($validWords{$word}==2){
		print color('bold red'),"You already tried that word, mate!\n", color('reset');
		return 1;
	}
	else{
		return 0
	}
	
}



