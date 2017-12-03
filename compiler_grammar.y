%{
	import java.io.*;
	import java.util.*;
%}

/* BYACC Declarations */
%token <sval> IDENTIFICADOR
%token <sval> INCLUSAO_ARQUIVO
%token <sval> COMENTARIO
%token <sval> COMENTARIO_MULTIPLO
%token <sval> NUMERO
%token <sval> FIM

%token ABRE_CHAVES
%token FECHA_CHAVES
%token ABRE_PARENTESES
%token FECHA_PARENTESES

%token FUNCAO_PRINCIPAL
%token FUNCAO_SECUNDARIA
%token INCLUIR

%token INTEIRO
%token REAL
%token CARACTER

%token RECEBE
%token INCREMENTA
%token DECREMENTA

%token SOMA
%token SUTRACAO
%token MULTIPLICACAO
%token DIVISAO
%token MODULO

%token MENOR
%token MENOR_IGUAL
%token MAIOR
%token MAIOR_IGUAL
%token IGUAL
%token DIFERENTE

%token PARA
%token SE

%type <sval> programa
%type <sval> funcao_principal
%type <sval> funcao_secundaria
%type <sval> inclusao
%type <sval> tipo
%type <sval> comandos
%type <sval> declaracao
%type <sval> parametro
%type <sval> operacao
%type <sval> comentario
%type <sval> comparacao
%type <sval> for
%type <sval> if

%%
inicio : programa	 { System.out.println($1); }

programa : inclusao programa			{ $$ = $1 + "\n" + $2; }
		 | funcao_principal programa 	{ $$ = $1 + "\n" + $2; }
		 | funcao_secundaria programa	{ $$ = $1 + "\n" + $2; }
		 | comentario programa			{ $$ = $1 + "\n" + $2; }
	     |								{ $$ = ""; }

comentario : COMENTARIO 		 { $$ = $1; }
		   | COMENTARIO_MULTIPLO { $$ = $1; }

funcao_principal : FUNCAO_PRINCIPAL ABRE_CHAVES comandos FECHA_CHAVES 													{ $$ = "\nint main() {\n" + $3 + "}"; }

funcao_secundaria : FUNCAO_SECUNDARIA tipo ABRE_PARENTESES parametro FECHA_PARENTESES ABRE_CHAVES comandos FECHA_CHAVES { $$ = "\nfunction " + $2 + "(" + $4 + ") {\n" + $7 + "}"; }

tipo : INTEIRO IDENTIFICADOR 	{ $$ = "int " + $2; }
	 | REAL IDENTIFICADOR	 	{ $$ = "double " + $2; }
	 | CARACTER IDENTIFICADOR	{ $$ = "char " + $2; }

parametro : INTEIRO IDENTIFICADOR 	{ $$ = "int " + $2; }
	 	  | REAL IDENTIFICADOR	 	{ $$ = "double " + $2; }
	      | CARACTER IDENTIFICADOR	{ $$ = "char " + $2; }
	      | 					    { $$ = ""; }


inclusao : INCLUIR INCLUSAO_ARQUIVO	{ $$ = "#include " + $2; }

comandos : declaracao		{ $$ = $1; }
		 |					{ $$ = ""; }

declaracao : INTEIRO IDENTIFICADOR comandos 														{ $$ = "    int " + $2 + ";\n" + $3; }
		   | REAL IDENTIFICADOR comandos															{ $$ = "    double " + $2 + ";\n" + $3; }
		   | CARACTER IDENTIFICADOR comandos														{ $$ = "    char " + $2 + ";\n" + $3; }
		   | IDENTIFICADOR RECEBE operacao comandos													{ $$ = "    " + $1 + " = " + $3 + ";\n" + $4; }
		   | IDENTIFICADOR INCREMENTA comandos 														{ $$ = "    " + $1 + "++;\n" + $3; }
		   | IDENTIFICADOR DECREMENTA comandos 														{ $$ = "    " + $1 + "--;\n" + $3; }
		   | IDENTIFICADOR comparacao comandos														{ $$ = "    " + $1 + $2 + "\n" + $3; }
		   | PARA ABRE_PARENTESES for FECHA_PARENTESES ABRE_CHAVES comandos FECHA_CHAVES comandos 	{ $$ = "    for(" + $3 + ") {\n    " + $6 + "    }\n" + $8; }
		   | SE ABRE_PARENTESES if FECHA_PARENTESES ABRE_CHAVES comandos FECHA_CHAVES comandos		{ $$ = "if("  + $3 + ") {\n    " + $6 + "    }\n" + $8; }

operacao : IDENTIFICADOR 								{ $$ = $1; }
		 | NUMERO										{ $$ = $1; }
         | IDENTIFICADOR SOMA IDENTIFICADOR 			{ $$ = $1 + " + " + $3; }
		 | IDENTIFICADOR SOMA NUMERO 					{ $$ = $1 + " + " + $3; }
		 | IDENTIFICADOR SUTRACAO IDENTIFICADOR 		{ $$ = $1 + " - " + $3; }
		 | IDENTIFICADOR SUTRACAO NUMERO		 		{ $$ = $1 + " - " + $3; }
		 | IDENTIFICADOR MULTIPLICACAO IDENTIFICADOR 	{ $$ = $1 + " * " + $3; }
		 | IDENTIFICADOR MULTIPLICACAO NUMERO		 	{ $$ = $1 + " * " + $3; }
		 | IDENTIFICADOR DIVISAO IDENTIFICADOR 			{ $$ = $1 + " / " + $3; }
		 | IDENTIFICADOR DIVISAO NUMERO 				{ $$ = $1 + " / " + $3; }
		 | NUMERO SOMA IDENTIFICADOR					{ $$ = $1 + " + " + $3; }
		 | NUMERO SOMA NUMERO							{ $$ = $1 + " + " + $3; }
		 | NUMERO SUTRACAO IDENTIFICADOR				{ $$ = $1 + " - " + $3; }
		 | NUMERO SUTRACAO NUMERO						{ $$ = $1 + " - " + $3; }
		 | NUMERO MULTIPLICACAO IDENTIFICADOR			{ $$ = $1 + " * " + $3; }
		 | NUMERO MULTIPLICACAO NUMERO					{ $$ = $1 + " * " + $3; }
		 | NUMERO DIVISAO IDENTIFICADOR					{ $$ = $1 + " / " + $3; }
		 | NUMERO DIVISAO NUMERO						{ $$ = $1 + " / " + $3; }
		 | IDENTIFICADOR MODULO	IDENTIFICADOR			{ $$ = $1 + " % " + $3; }
		 | IDENTIFICADOR MODULO	NUMERO					{ $$ = $1 + " % " + $3; }
		 | NUMERO MODULO IDENTIFICADOR					{ $$ = $1 + " % " + $3; }
		 | NUMERO MODULO NUMERO							{ $$ = $1 + " % " + $3; }


comparacao : MENOR IDENTIFICADOR 		{ $$ = " < " + $2; }
		   | MENOR NUMERO 		 		{ $$ = " < " + $2; }
		   | MENOR_IGUAL IDENTIFICADOR 	{ $$ = " <= " + $2; }
		   | MENOR_IGUAL NUMERO 		{ $$ = " <= " + $2; }
		   | MAIOR IDENTIFICADOR 		{ $$ = " > " + $2; }
		   | MAIOR NUMERO 		 		{ $$ = " > " + $2; }
		   | MAIOR_IGUAL IDENTIFICADOR 	{ $$ = " >= " + $2; }
		   | MAIOR_IGUAL NUMERO 		{ $$ = " >= " + $2; }
		   | IGUAL IDENTIFICADOR	 	{ $$ = " == " + $2; }
		   | IGUAL NUMERO				{ $$ = " == " + $2; }
		   | DIFERENTE IDENTIFICADOR 	{ $$ = " != " + $2; }
		   | DIFERENTE NUMERO			{ $$ = " != " + $2; }


for : IDENTIFICADOR RECEBE IDENTIFICADOR FIM for		{ $$ = $1 + " = " + $3 + "; " + $5; }
	| IDENTIFICADOR RECEBE operacao FIM for				{ $$ = $1 + " = " + $3 + "; " + $5; }
	| IDENTIFICADOR comparacao FIM for 					{ $$ = $1 + $2 + "; " + $4; }
	| IDENTIFICADOR RECEBE NUMERO FIM for				{ $$ = $1 + " = " + $3 + "; " + $5; }
	| NUMERO comparacao FIM for 						{ $$ = $1 + $2 + "; " + $4; }
	| IDENTIFICADOR INCREMENTA comandos 				{ $$ = $1 + "++" + $3; }
	| IDENTIFICADOR DECREMENTA comandos 				{ $$ = $1 + "--" + $3; }
	| 													{ $$ = ""; }


if : IDENTIFICADOR comparacao							{ $$ = $1 + $2; }
   | IDENTIFICADOR operacao comparacao					{ $$ = $1 + $2 + $3; }
   | NUMERO comparacao									{ $$ = $1 + $2; }
   | NUMERO operacao comparacao							{ $$ = $1 + $2 + $3; }
   | NUMERO												{ $$ = $1; }
   | IDENTIFICADOR										{ $$ = $1; }


%%

	// Referencia ao JFlex
	private Yylex lexer;

	/* Interface com o JFlex */
	private int yylex(){
		int yyl_return = -1;
		try {
			yyl_return = lexer.yylex();
		} catch (IOException e) {
			System.err.println("Erro de IO: " + e);
		}
		return yyl_return;
	}

	/* Reporte de erro */
	public void yyerror(String error){
		System.err.println("Error: " + error);
	}

	// Interface com o JFlex eh criado no construtor
	public Parser(Reader r){
		lexer = new Yylex(r, this);
	}

	// Main
	public static void main(String[] args){
		try{
			Parser yyparser = new Parser(new FileReader(args[0]));
			yyparser.yyparse();
			} catch (IOException ex) {
				System.err.println("Error: " + ex);
			}
	}
