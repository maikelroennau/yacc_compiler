del *.class 2> NUL
del *.java 2> NUL
del yacc.* 2> NUL

yacc -J compiler_grammar.y
jflex.jar compiler_parser.jflex
javac *.java
