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
%token <sval> LETRA

%token ABRE_CHAVES
%token FECHA_CHAVES
%token ABRE_PARENTESES
%token FECHA_PARENTESES
%token ABRE_COLCHETES
%token FECHA_COLCHETES

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
%token SENAO
%token ENQUANTO
%token FACA
%token ATE
%token RETORNAR

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
%type <sval> argumento
%type <sval> concatenacao
%type <sval> array

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

argumento : IDENTIFICADOR           { $$ = $1; }
		  | NUMERO					{ $$ = $1; }
		  | LETRA					{ $$ = $1; }
		  | operacao				{ $$ = $1; }
		  |							{ $$ = ""; }


inclusao : INCLUIR INCLUSAO_ARQUIVO	{ $$ = "#include " + $2; }

comandos : declaracao																				   									{ $$ = $1; }
		 | PARA ABRE_PARENTESES for FECHA_PARENTESES ABRE_CHAVES comandos FECHA_CHAVES comandos				 							{ $$ = "    for(" + $3 + ") {\n    " + $6 + "    }\n" + $8; }
		 | SE ABRE_PARENTESES if FECHA_PARENTESES ABRE_CHAVES comandos FECHA_CHAVES comandos											{ $$ = "    if("  + $3 + ") {\n    " + $6 + "    }\n" + $8; }
		 | SE ABRE_PARENTESES if FECHA_PARENTESES ABRE_CHAVES comandos FECHA_CHAVES SENAO ABRE_CHAVES comandos FECHA_CHAVES comandos	{ $$ = "    if("  + $3 + ") {\n    " + $6 + "    } senao {\n    " + $10 + "    }\n" + $12; }
		 | SE ABRE_PARENTESES if FECHA_PARENTESES comandos				 																{ $$ = "    if("  + $3 + ")\n    " + $5; }
		 | ENQUANTO ABRE_PARENTESES if FECHA_PARENTESES ABRE_CHAVES comandos FECHA_CHAVES comandos										{ $$ = "    while(" + $3 + ") {\n    "+ $6 + "    }\n" + $8; }
		 | FACA ABRE_CHAVES comandos FECHA_CHAVES ATE ABRE_PARENTESES if FECHA_PARENTESES comandos										{ $$ = "    do{\n    " + $3 + "} while(" + $7 + ");\n" + $9; }		 
		 | RETORNAR IDENTIFICADOR																										{ $$ = "    return " + $2 + ";\n"; }
		 | RETORNAR NUMERO																												{ $$ = "    return " + $2 + ";\n"; }
		 | RETORNAR LETRA																												{ $$ = "    return " + $2 + ";\n"; }
		 |																																{ $$ = ""; }


declaracao : INTEIRO IDENTIFICADOR array comandos					 																				{ $$ = "    int " + $2 + $3 + ";\n" + $4; }
		   | REAL IDENTIFICADOR array comandos																										{ $$ = "    double " + $2 + $3 + ";\n" + $4; }
		   | CARACTER IDENTIFICADOR array comandos																									{ $$ = "    char " + $2 + $3 + ";\n" + $4; }
		   | IDENTIFICADOR RECEBE operacao comandos																									{ $$ = "    " + $1 + " = " + $3 + ";\n" + $4; }
		   | IDENTIFICADOR array RECEBE operacao comandos																							{ $$ = "    " + $1 + $2 + " = " + $4 + ";\n" + $5; }
		   | IDENTIFICADOR INCREMENTA comandos 																										{ $$ = "    " + $1 + "++;\n" + $3; }
		   | IDENTIFICADOR DECREMENTA comandos 																										{ $$ = "    " + $1 + "--;\n" + $3; }
		   | IDENTIFICADOR comparacao comandos																										{ $$ = "    " + $1 + $2 + "\n" + $3; }
		   | IDENTIFICADOR ABRE_PARENTESES argumento FECHA_PARENTESES comandos																		{ $$ = "    " + $1 + "(" + $3 + ")" + $5 + ";\n"; }
		   | IDENTIFICADOR ABRE_PARENTESES argumento FECHA_PARENTESES concatenacao comandos		  							 						{ $$ = "    " + $1 + "(" + $3 + ")" + $5 + ";\n" + $6; }
		   | ABRE_PARENTESES IDENTIFICADOR ABRE_PARENTESES argumento FECHA_PARENTESES FECHA_PARENTESES comandos				 						{ $$ = "    (" + $2 + "(" + $4 + "));\n" + $7; }
		   | ABRE_PARENTESES IDENTIFICADOR ABRE_PARENTESES argumento FECHA_PARENTESES concatenacao FECHA_PARENTESES comandos						{ $$ = "    (" + $2 + "(" + $4 + ")" + $6 + ");\n" + $8; }
		   | IDENTIFICADOR RECEBE IDENTIFICADOR ABRE_PARENTESES argumento FECHA_PARENTESES comandos													{ $$ = "    " + $1 + " = " + $3 + "(" + $5 + ");\n" + $7; }
		   | IDENTIFICADOR RECEBE IDENTIFICADOR ABRE_PARENTESES argumento FECHA_PARENTESES concatenacao comandos 									{ $$ = "    " + $1 + " = " + $3 + "(" + $5 + ")" + $7 + ";\n" + $8; }
		   | IDENTIFICADOR RECEBE ABRE_PARENTESES IDENTIFICADOR ABRE_PARENTESES argumento FECHA_PARENTESES FECHA_PARENTESES comandos 				{ $$ = "    " + $1 + " = (" + $4 + "(" + $6 + "));\n" + $9; }
   		   | IDENTIFICADOR RECEBE ABRE_PARENTESES IDENTIFICADOR ABRE_PARENTESES argumento FECHA_PARENTESES concatenacao FECHA_PARENTESES comandos 	{ $$ = "    " + $1 + " = (" + $4 + "(" + $6 + ")" + $8 + ");\n" + $10; }
		   | IDENTIFICADOR array RECEBE IDENTIFICADOR ABRE_PARENTESES argumento FECHA_PARENTESES comandos													{ $$ = "    " + $1 + $2 + " = " + $4 + "(" + $6 + ");\n" + $8; }
		   | IDENTIFICADOR array RECEBE IDENTIFICADOR ABRE_PARENTESES argumento FECHA_PARENTESES concatenacao comandos 										{ $$ = "    " + $1 + $2 + " = " + $4 + "(" + $6 + ")" + $8 + ";\n" + $9; }
		   | IDENTIFICADOR array RECEBE ABRE_PARENTESES IDENTIFICADOR ABRE_PARENTESES argumento FECHA_PARENTESES FECHA_PARENTESES comandos 					{ $$ = "    " + $1 + $2 + " = (" + $5 + "(" + $7 + "));\n" + $10; }
   		   | IDENTIFICADOR array RECEBE ABRE_PARENTESES IDENTIFICADOR ABRE_PARENTESES argumento FECHA_PARENTESES concatenacao FECHA_PARENTESES comandos 	{ $$ = "    " + $1 + $2 + " = (" + $5 + "(" + $7 + ")" + $9 + ");\n" + $11; }


operacao : IDENTIFICADOR 									{ $$ = $1; }
		 | NUMERO											{ $$ = $1; }
         | IDENTIFICADOR SOMA IDENTIFICADOR 				{ $$ = $1 + " + " + $3; }
		 | IDENTIFICADOR SOMA NUMERO 						{ $$ = $1 + " + " + $3; }
		 | IDENTIFICADOR SUTRACAO IDENTIFICADOR		 		{ $$ = $1 + " - " + $3; }
		 | IDENTIFICADOR SUTRACAO NUMERO		 			{ $$ = $1 + " - " + $3; }
		 | IDENTIFICADOR MULTIPLICACAO IDENTIFICADOR 		{ $$ = $1 + " * " + $3; }
		 | IDENTIFICADOR MULTIPLICACAO NUMERO			 	{ $$ = $1 + " * " + $3; }
		 | IDENTIFICADOR DIVISAO IDENTIFICADOR 				{ $$ = $1 + " / " + $3; }
		 | IDENTIFICADOR DIVISAO NUMERO 					{ $$ = $1 + " / " + $3; }
		 | NUMERO SOMA IDENTIFICADOR						{ $$ = $1 + " + " + $3; }
		 | NUMERO SOMA NUMERO								{ $$ = $1 + " + " + $3; }
		 | NUMERO SUTRACAO IDENTIFICADOR					{ $$ = $1 + " - " + $3; }
		 | NUMERO SUTRACAO NUMERO							{ $$ = $1 + " - " + $3; }
		 | NUMERO MULTIPLICACAO IDENTIFICADOR				{ $$ = $1 + " * " + $3; }
		 | NUMERO MULTIPLICACAO NUMERO						{ $$ = $1 + " * " + $3; }
		 | NUMERO DIVISAO IDENTIFICADOR						{ $$ = $1 + " / " + $3; }
		 | NUMERO DIVISAO NUMERO							{ $$ = $1 + " / " + $3; }
		 | IDENTIFICADOR MODULO	IDENTIFICADOR				{ $$ = $1 + " % " + $3; }
		 | IDENTIFICADOR MODULO	NUMERO						{ $$ = $1 + " % " + $3; }
		 | NUMERO MODULO IDENTIFICADOR						{ $$ = $1 + " % " + $3; }
		 | NUMERO MODULO NUMERO								{ $$ = $1 + " % " + $3; }


concatenacao : SOMA NUMERO concatenacao					    { $$ = " + " + $2 + $3; }
		     | SOMA IDENTIFICADOR concatenacao			    { $$ = " + " + $2 + $3; }
		     | SUTRACAO NUMERO concatenacao				    { $$ = " - " + $2 + $3; }
		 	 | SUTRACAO IDENTIFICADOR concatenacao		    { $$ = " - " + $2 + $3; }
	 		 | MULTIPLICACAO NUMERO concatenacao		    { $$ = " * " + $2 + $3; }
	  	     | MULTIPLICACAO IDENTIFICADOR concatenacao	    { $$ = " * " + $2 + $3; }
			 | DIVISAO NUMERO concatenacao				    { $$ = " / " + $2 + $3; }
			 | DIVISAO IDENTIFICADOR concatenacao		    { $$ = " / " + $2 + $3; }
			 | MODULO NUMERO concatenacao				    { $$ = " % " + $2 + $3; }
		     | MODULO IDENTIFICADOR concatenacao		    { $$ = " % " + $2 + $3; }
			 | 												{ $$ = ""; }


comparacao : MENOR IDENTIFICADOR 							{ $$ = " < " + $2; }
		   | MENOR NUMERO 		 							{ $$ = " < " + $2; }
		   | MENOR_IGUAL IDENTIFICADOR 						{ $$ = " <= " + $2; }
		   | MENOR_IGUAL NUMERO 							{ $$ = " <= " + $2; }
		   | MAIOR IDENTIFICADOR 							{ $$ = " > " + $2; }
		   | MAIOR NUMERO 		 							{ $$ = " > " + $2; }
		   | MAIOR_IGUAL IDENTIFICADOR 						{ $$ = " >= " + $2; }
		   | MAIOR_IGUAL NUMERO 							{ $$ = " >= " + $2; }
		   | IGUAL IDENTIFICADOR	 						{ $$ = " == " + $2; }
		   | IGUAL NUMERO									{ $$ = " == " + $2; }
		   | DIFERENTE IDENTIFICADOR 						{ $$ = " != " + $2; }
		   | DIFERENTE NUMERO								{ $$ = " != " + $2; }


for : IDENTIFICADOR RECEBE IDENTIFICADOR FIM for			{ $$ = $1 + " = " + $3 + "; " + $5; }
	| IDENTIFICADOR RECEBE operacao FIM for					{ $$ = $1 + " = " + $3 + "; " + $5; }
	| IDENTIFICADOR comparacao FIM for 						{ $$ = $1 + $2 + "; " + $4; }
	| IDENTIFICADOR RECEBE NUMERO FIM for					{ $$ = $1 + " = " + $3 + "; " + $5; }
	| NUMERO comparacao FIM for 							{ $$ = $1 + $2 + "; " + $4; }
	| IDENTIFICADOR INCREMENTA comandos 					{ $$ = $1 + "++" + $3; }
	| IDENTIFICADOR DECREMENTA comandos 					{ $$ = $1 + "--" + $3; }
	| 														{ $$ = ""; }


if : IDENTIFICADOR comparacao								{ $$ = $1 + $2; }
   | NUMERO comparacao										{ $$ = $1 + $2; }
   | operacao comparacao									{ $$ = $1 + $2; }
   | NUMERO													{ $$ = $1; }
   | IDENTIFICADOR											{ $$ = $1; }

array : ABRE_COLCHETES IDENTIFICADOR FECHA_COLCHETES		{ $$ = "[" + $2 + "]"; }
	  | ABRE_COLCHETES NUMERO FECHA_COLCHETES				{ $$ = "[" + $2 + "]"; }
	  | 													{ $$ = ""; }


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
