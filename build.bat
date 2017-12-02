del *.class
del *.java

yacc -J compiler_grammar.y
jflex.jar compiler_parser.jflex
javac *.java
