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

funcao_principal 	{ return Parser.FUNCAO_PRINCIPAL; }
funcao 				{ return Parser.FUNCAO_SECUNDARIA; }

incluir	{ return Parser.INCLUIR; }
inteiro { return Parser.INTEIRO; }
real { return Parser.REAL; }
caracter { return Parser.CARACTER; }

\<.*\>	{ yyparser.yylval = new ParserVal(yytext());
		  return Parser.INCLUSAO_ARQUIVO; }


"{"	{ return Parser.ABRE_CHAVES; }
"}" { return Parser.FECHA_CHAVES; }
"(" { return Parser.ABRE_PARENTESES; }
")" { return Parser.FECHA_PARENTESES; }


"+"  { return Parser.SOMA; }
"-"  { return Parser.SUTRACAO; }
"*"  { return Parser.MULTIPLICACAO; }
"/"  { return Parser.DIVISAO; }

":=" { return Parser.RECEBE; }
"++" { return Parser.INCREMENTA; }
"--" { return Parser.DECREMENTA; }


[a-zA-Z_][a-zA-Z0-9_]*	{ 
		yyparser.yylval = new ParserVal(yytext());
		return Parser.IDENTIFICADOR;
	}
{NL}|" "|\t	{  }
