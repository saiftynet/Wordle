#!/usr/bin/env perl
use strict;use warnings;

my $VERSION=0.04;

BEGIN {  # attempt to get this to work on Windows Consoles
   if ($^O eq 'MSWin32') {
	 require  'Win32\Console\ANSI.pm';
   }
   Win32::Console::ANSI->import;
}
use Term::ANSIColor;  # allow coloured terminal output

my $wordLength=5;     # set number of letters 
my $maxGuesses=6;     # set number of guesses 
my $source    =  "/usr/share/dict/words";

my (@rows, $goes,$guess,%workspace,@keyboard,%scores);
$scores{$_}=0 foreach (1..$maxGuesses,"wins","fails");

my @help=(
"   Try and guess a $wordLength letter word in $maxGuesses moves"," ",
color("green")."   Green ".color("reset")."  = Right letter in right place",
color("yellow")."   Yellow ". color("reset")." = Right letter in wrong place",
"   Keyboard ".color("red"). " Red ". color("reset")." = letter not found in word", 
"   Keyboard ".color("cyan"). " Cyan ". color("reset")."= letter found in word", );

# load the valid words from Unix Dictionary
my %validWords=();
open my $fh, "<", $source; 
foreach my $word (<$fh>){
	$validWords{uc($1)}=1 if ($word=~m/^([a-z]{$wordLength})\n?$/)
}
close $fh;

#main game loop
while (!$goes || prompt("\nWant another game Y/N?")=~/^y/i){
	@rows=("|"."   |"x$wordLength)x$maxGuesses;   #empty cells
	$guess=""; $goes=0; %workspace=(gotIt=>0, guessList=>[]);
	@keyboard=("    Q  W  E  R  T  Y  U  I  O  P ",
              "      A  S  D  F  G  H  J  K  L ",
              "        Z  X  C  V  B  N  M ",);
	my $answer=(keys %validWords)[ rand keys %validWords ];
		
	while (!$workspace{gotIt} && $goes++  < $maxGuesses){
		drawTable();
		while ($guess eq "" || notValid($guess)){
			$guess=uc(prompt("Guess $goes >>"));
		}
		$validWords{$guess}=2;
		updateKeyboard($guess,$answer);      # Colour keyboard
		match($guess,$answer);               # check for match
		$rows[$goes-1]=$workspace{show};     # populate row
		$guess="";                           # reset guess
	}
	drawTable();

	if ($workspace{gotIt}){ 
		print "\nWell done!! Guessed it in $goes\nScore:- ";
		$scores{wins}++;$scores{$goes}++;
	}
	else{
		print "Failed!! answer was $answer\nScore:- ";
		$scores{fails}++
	}
	print " $_=$scores{$_} ;" foreach (sort keys %scores);
	$validWords{$_}=1 foreach (@{$workspace{guessList}});   # reset guessed words
}

sub drawTable{ # draws the saved rows, the help message and the keyboard
	system $^O eq 'MSWin32' ? 'cls':'clear';
	print color("bright_magenta")."                      W O R D L E  in  P E R L \n\n".color("reset");
	my $rowseparator="       +".("---+" x $wordLength);
	my $line=0;
	my @helpText=(@help," ",@keyboard);
	foreach my $row(@rows){
		print $rowseparator   ,($helpText[$line])?$helpText[$line++]:"","\n",
		      "       $row",($helpText[$line])?$helpText[$line++]:"","\n";
	}
	print $rowseparator,"\n";
}

# this subroutine checks, gets matches, generates row data
sub match{  
	my ($guess,$answer)=@_;
	my @colours=(color("reset"),color("green"),color("yellow"));
	$workspace{gotIt}=($guess eq $answer)?1:0;
	$workspace{guess}=[split (//,$guess)];
	$workspace{guessList}=[@{$workspace{guessList}},$guess];
	$workspace{answer}=[split (//,$answer)];
	$workspace{match}=[map {$workspace{guess}[$_ ] eq $workspace{answer}[$_ ]?1:0} (0..($wordLength-1)) ]; 
	$workspace{match}=[map {$workspace{match}[$_ ]==1? $workspace{match}[$_ ]:($answer=~/$workspace{guess}[$_ ]/i?2:0) } (0..($wordLength-1)) ];
	$workspace{show} ="| ".join (" | ",map {
		       $colours[$workspace{match}[$_ ]].
		       $workspace{guess}[$_ ].color("reset");
		       }  (0..($wordLength-1)))." |";
}

sub updateKeyboard{  # this uses guessed characters to colour keyboard
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
	print color('bold yellow'),$pr,">>",color('bold green');
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
