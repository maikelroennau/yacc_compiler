# Yacc compiler to C
Compiler built for fictional programming language.

## Pre-requisits

- Have [BYacc/J](http://byaccj.sourceforge.net/) under your `PATH` environment variable, so you can run `yacc.exe` from console.
- Have [JFlex](http://jflex.de/) under your `PATH` environment variable, so you can run `jflex.jar` from console.

## How to run

- Run `build.bat` in the console to build the parser.
- Then run `run.bat <FILE.ct>` to compile the `CT` code to `C`.


## How add new compilation commands

- Updated the file `compiler_grammar.y` adding the new grammar rules
- Update the file `compiler_parser.jflex` adding the new parser rules reflecting the grammar

## Author

**Maikel Maciel Rönnau**  
*Computer Scientist  
maikel.ronnau@gmail.com  
[Linkedin](https://br.linkedin.com/in/maikelronnau) - [GitHub](https://github.com/maikelronnau)*
