%{
	import java.io.*;
	import java.util.*;
%}

/* BYACC Declarations */
%token <sval> IDENTIFICADOR
%token <sval> INCLUSAO_ARQUIVO
%token ABRE_CHAVES
%token FECHA_CHAVES
%token FUNCAO_PRINCIPAL
%token FUNCAO_SECUNDARIA
%token INCLUIR
%token INTEIRO
%token REAL
%token CARACTER
%type <sval> programa
%type <sval> funcao_principal
%type <sval> funcao_secundaria
%type <sval> tipo
%type <sval> inclusao
%type <sval> comandos
%type <sval> declaracao

%%
inicio : programa	 { System.out.println($1); }

programa : inclusao programa			{ $$ = $1 + "\n" + $2; }
		 | funcao_principal programa 	{ $$ = $1 + "\n" + $2; }
		 | funcao_secundaria programa	{ $$ = $1 + "\n" + $2; }
	     |								{ $$ = ""; }

funcao_principal : FUNCAO_PRINCIPAL ABRE_CHAVES comandos FECHA_CHAVES 					{ $$ = "\nint main() {\n " + $3 + "}\n"; }

funcao_secundaria : FUNCAO_SECUNDARIA tipo ABRE_CHAVES comandos FECHA_CHAVES programa	{ $$ = "\nfunction " + $2 + " {\n" + $4 + "}\n" + $6; }

tipo : INTEIRO IDENTIFICADOR 	{ $$ = "int " + $2; }
	 | REAL IDENTIFICADOR	 	{ $$ = "double " + $2; }
	 | CARACTER IDENTIFICADOR	{ $$ = "char " + $2; }



inclusao : INCLUIR INCLUSAO_ARQUIVO	{ $$ = "#include " + $2; }

comandos : declaracao		{ $$ = $1; }
		 |					{ $$ = ""; }

declaracao : INTEIRO IDENTIFICADOR comandos {  $$ = " int " + $2 + ";\n" + $3; }
		   | REAL IDENTIFICADOR comandos	{  $$ = " double " + $2 + ";\n" + $3; }
		   | CARACTER IDENTIFICADOR comandos	{  $$ = " char " + $2 + ";\n" + $3; }

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
