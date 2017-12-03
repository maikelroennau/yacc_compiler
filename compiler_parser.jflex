import java.io.*;

%%

%byaccj

%{

	// Armazena uma referencia para o parser
	private Parser yyparser;

	// Construtor recebendo o parser como parametro adicional
	public Yylex(Reader r, Parser yyparser){
		this(r);
		this.yyparser = yyparser;
	}

%}

NL = \n | \r | \r\n

%%

\/\/.* {
		yyparser.yylval = new ParserVal(yytext());
		return Parser.COMENTARIO; }

\/\*.*\*\/ {
		yyparser.yylval = new ParserVal(yytext());
		return Parser.COMENTARIO_MULTIPLO; }


funcao_principal 	{ return Parser.FUNCAO_PRINCIPAL; }
funcao 				{ return Parser.FUNCAO_SECUNDARIA; }

incluir	{ return Parser.INCLUIR; }
inteiro { return Parser.INTEIRO; }
real { return Parser.REAL; }
caracter { return Parser.CARACTER; }

para 		{ return Parser.PARA; }
se 	 		{ return Parser.SE; }
senao		{ return Parser.SENAO; }
enquanto	{ return Parser.ENQUANTO; }
faca		{ return Parser.FACA; }
ate			{ return Parser.ATE; }
retornar 	{ return Parser.RETORNAR; }

\<.*\>	{ yyparser.yylval = new ParserVal(yytext());
		  return Parser.INCLUSAO_ARQUIVO; }


"{"	{ return Parser.ABRE_CHAVES; }
"}" { return Parser.FECHA_CHAVES; }
"(" { return Parser.ABRE_PARENTESES; }
")" { return Parser.FECHA_PARENTESES; }
"[" { return Parser.ABRE_COLCHETES; }
"]" { return Parser.FECHA_COLCHETES; }

[0-9]* {
	yyparser.yylval = new ParserVal(yytext());
	return Parser.NUMERO; }

(')[a-zA-Z](') {
	yyparser.yylval = new ParserVal(yytext());
	return Parser.LETRA; }

"+"  { return Parser.SOMA; }
"-"  { return Parser.SUTRACAO; }
"*"  { return Parser.MULTIPLICACAO; }
"/"  { return Parser.DIVISAO; }
"%"  { return Parser.MODULO; }

":=" { return Parser.RECEBE; }
"++" { return Parser.INCREMENTA; }
"--" { return Parser.DECREMENTA; }

"<"  { return Parser.MENOR; }
"<=" { return Parser.MENOR_IGUAL; }
">"  { return Parser.MAIOR; }
">=" { return Parser.MAIOR_IGUAL; }
"==" { return Parser.IGUAL; }
"!=" { return Parser.DIFERENTE; }
";"  { return Parser.FIM; }

[a-zA-Z_][a-zA-Z0-9_]*	{
	yyparser.yylval = new ParserVal(yytext());
	return Parser.IDENTIFICADOR; }

{NL}|" "|\t	{  }
