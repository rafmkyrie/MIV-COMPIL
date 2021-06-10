%{
	#include<stdlib.h>
	#include <stdio.h>
	#include <string.h>

	#include "TS.h"

	extern FILE* yyin ;
	extern int line, column;

	char type[10];

	int yyparse();
	int yylex();
	int yyerror(char *msg);
    
    
%}

%union {
int entier;
char* str;
}

%token MC_CODE MC_START MC_END MC_CONST MC_PROD MC_WHILE MC_EXECUTE MC_WHEN MC_DO MC_OTHERWISE MC_EQ MC_LT MC_GT MC_LE MC_GE MC_NE DOLLAR PLUS MOINS MUL DIV AFFECTATION VIRGULE POINTVIRGULE PARANTHESE_OUVRANTE PARANTHESE_FERMANTE ACCOLADE_OUVRANTE ACCOLADE_FERMANTE
%token <str>IDF <str>MC_INTEGER <str>MC_REAL <str>MC_CHAR <str>MC_STRING
%token <str>INTEGER <str>INTEGER_SIGNE <str>REAL <str>CHAR <str>STRING 

%type <str>Type
%type <str>Valeur
%type <str>ValNum
%type <str>ExprAr

%left Plus Moins
%left MUL DIV 
%left MC_EQ MC_LT MC_GT MC_LE MC_GE MC_NE


%start S

%%

S : EnTete BlocDeclaration BlocInstructions  { printf("Syntaxe correcte");      YYACCEPT; }
;   

EnTete : MC_CODE IDF { inserervc($2,"","PROG",""); }


// #####################    BLOC DE DECLARATION

BlocDeclaration :    DecCst BlocDeclaration
			|	DecVar BlocDeclaration
			|
			;

DecCst : MC_CONST Type IDF AFFECTATION Valeur POINTVIRGULE {
															comparerType($2,type); inserervc($3, "CONST", $2, $5);} ;

Type : MC_INTEGER {$$=$1;}
        | MC_REAL {$$=$1;}
	    | MC_CHAR {$$=$1;}
	    | MC_STRING {$$=$1;}
	    ;

Valeur : CHAR {strcpy(type, "CHAR"); $$ = $1;}
      | STRING  {strcpy(type, "STRING"); $$ = $1;}
	  | REAL {strcpy(type, "REAL"); $$ = $1;}
	  | INTEGER {strcpy(type, "INTEGER"); $$ = $1;}
      | INTEGER_SIGNE {strcpy(type, "INTEGER"); $$ = $1;}
	  ;

DecVar : Type {strcpy(type, $1);} ListeIdf POINTVIRGULE 
        ;

ListeIdf : IDF  {inserervc($1, "VAR", type, "");}
         | IDF VIRGULE ListeIdf {inserervc($1, "VAR", type, "");}
		 ;


// #####################    BLOC DES INSTRUCTIONS

BlocInstructions : MC_START ListeInstructions MC_END;

ListeInstructions : Instruction ListeInstructions
             |
			 ;

Instruction : Affectation 
	| Controle
	| Boucle
	   ;

// #### Expression Arithmétique

ExprAr :  ValNum PLUS ExprAr 		{	}  
        | ValNum MOINS ExprAr 		{	}
        | ValNum MUL ExprAr 		{	}
		| ValNum DIV ExprAr 	{ if(atof($3)==0) {printf("Ligne %d:%d  Erreur semantique: division par zero\n",line, column);exit(0);} }
		| ValNum { } 
		;

ValNum :  IDF 	{ 
					exist($1); comparerType(getType($1),"REAL"); 
					$$ = getVal($1); 
					
				} 
         | INTEGER {$$ = $1;} 
         | INTEGER_SIGNE {$$ = $1;}
		 | REAL {$$ = $1;}
		 ;

// #### Expression Logique

ExprL : ExprAr OperateurL ExprAr { };

OperateurL : MC_EQ {}
       | MC_GE {}
	   | MC_GT {}
	   | MC_LE {}
	   | MC_LT {}
	   | MC_NE {}
	   ;


// ##### AFFECTATION

Affectation : IDF AFFECTATION MembreDroit POINTVIRGULE {	
															exist($1); // vérifie l'existance l'IDF dans la TS															
															if(isConst($1)) {
																printf("Erreur semantique : changement de valeur d'une constante !");
																exit(0);
															}
															comparerType(getType($1),type); // compare les types de l'idf avec celui du membre droit


														};

MembreDroit : ExprAr {strcpy(type, "REAL");}
              | Produit {strcpy(type,"REAL");}
              | CHAR {strcpy(type, "CHAR");}
              | STRING	{strcpy(type, "STRING");}
              ;

Produit : MC_PROD PARANTHESE_OUVRANTE ListeProduit PARANTHESE_FERMANTE;

ListeProduit : ExprAr
        | ListeProduit VIRGULE ExprAr;

// ##### BOUCLE

Boucle : MC_WHILE ExprL MC_EXECUTE ACCOLADE_OUVRANTE ListeInstructions ACCOLADE_FERMANTE POINTVIRGULE;

// ##### Controle

Controle : MC_WHEN ExprL MC_DO ListeInstructions MC_OTHERWISE ListeInstructions POINTVIRGULE;



%%

int main(int argc, const char *argv[]){

	yyin = fopen("exemple.txt", "r");
	if (yyin==NULL) {printf("Error \n");}
	else {yyparse(); affichertout();}
	return 0;
	
}

int yyerror(char* msg){
	//printf("\nErreur syntaxique : %s ligne : %d    colonne : %d\n", msg, line, column);
	printf("Line %d, Column %d : %s", line, column, msg);
}
