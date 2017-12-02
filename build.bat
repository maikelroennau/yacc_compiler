del *.class
del *.java
del yacc.*

yacc -J compiler_grammar.y
jflex.jar compiler_parser.jflex
javac *.java
