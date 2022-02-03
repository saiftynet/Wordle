# Wordle in Perl

A command Line Wordle clone.

This is a natural response to a newsletter post [Perl Weekly News](https://perlweekly.com/archive/549.html) which ended "Any way, this has nothing to do with Perl".

It is a simple command line Perl application that is sort of replicates the Wordle Application. Would be nice to make it better, serve up diferent languages and work in different platforms. It relies on [Term::ANSIColor](https://metacpan.org/pod/Term::ANSIColor) and maybe [Win32::Console::ANSI](https://metacpan.org/release/JLMOREL/Win32-Console-ANSI-1.11/view/lib/Win32/Console/ANSI.pm).  I say maybe, because this version uses the Unix dictionary file in "/usr/share/dict/words".  Scope is left to allow different lengths of words and different numbers of guesses.


![image](https://user-images.githubusercontent.com/34284663/152206350-da263af5-95ea-4ac4-8656-c8e0dce19a22.png)

![image](https://user-images.githubusercontent.com/34284663/152414078-e5926719-e001-4eef-8ba0-549a93f38156.png)

CHANGES
V0.02
1) [hymie0](https://github.com/saiftynet/Wordle/issues?q=is%3Aissue+is%3Aopen+author%3Ahymie0) detected bug that seen words remain seen between games...addresses by restoring validWords hash
2) Consoles with white backgrounds not catered for; addressed for now by using color("reset") instead of color("white")

V0.03

Added help message
