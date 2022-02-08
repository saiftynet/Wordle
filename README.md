# Wordle in Perl

A command Line Wordle clone.

This is a natural response to a newsletter post [Perl Weekly News](https://perlweekly.com/archive/549.html) which ended "Any way, this has nothing to do with Perl".

It is a simple command line Perl application that is sort of replicates the Wordle Application. Would be nice to make it better, serve up diferent languages and work in different platforms. It relies on [Term::ANSIColor](https://metacpan.org/pod/Term::ANSIColor) and maybe [Win32::Console::ANSI](https://metacpan.org/release/JLMOREL/Win32-Console-ANSI-1.11/view/lib/Win32/Console/ANSI.pm).  This version uses a "words" file in the dame directory as the program. If this file is not present, the Unix dictionary file in "/usr/share/dict/words" is tried.  Scope is left to allow different lengths of words and different numbers of guesses. 

![image](https://user-images.githubusercontent.com/34284663/152427381-516d91e1-4424-4f18-859e-164b5627e8d8.png)

now with game statistics

![image](https://user-images.githubusercontent.com/34284663/153064952-b6b13645-90ed-46b0-a520-d57518519c68.png)


CHANGES

V0.02
1) [hymie0](https://github.com/saiftynet/Wordle/issues?q=is%3Aissue+is%3Aopen+author%3Ahymie0) detected bug that seen words remain seen between games...addresses by restoring validWords hash
2) Consoles with white backgrounds not catered for; addressed for now by using color("reset") instead of color("white")

V0.03
1) Added help message

V0.05
1) Added  statistics including game time, histogram
2) Improved algorithm for getting matches

v0.06
1) better looking stats including win and fail counts
2) [bug](https://github.com/saiftynet/Wordle/issues/3) squished by [hymie0](https://github.com/hymie0)


