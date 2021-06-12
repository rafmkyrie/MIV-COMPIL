%{
	#include<stdlib.h>
	#include <stdio.h>
	#include <string.h>

	#include "TS.h"

	extern FILE* yyin ;
	extern int line, column;

	char type[10], ns[5], op1[10], op2[10], temp[10], tempL[10], buf[5], valL[10];
	int n=1, nL=1, saveqcL, saveqcL2, op, save_brIF, save_bzIF, save_bzWHILE, save_bzWHILE1;

	int yyparse();
	int yylex();
	int yyerror(char *msg);
    
    
%}

%union {
int entier;
char* str;
}

%token MC_CODE MC_START MC_END MC_CONST MC_PROD MC_WHILE MC_EXECUTE MC_WHEN MC_DO MC_OTHERWISE MC_EQ MC_LT MC_GT MC_LE MC_GE MC_NE 
%token PLUS MOINS MUL DIV AFFECTATION DOLLAR VIRGULE POINTVIRGULE PARANTHESE_OUVRANTE PARANTHESE_FERMANTE ACCOLADE_OUVRANTE ACCOLADE_FERMANTE
%token <str>IDF <str>MC_INTEGER <str>MC_REAL <str>MC_CHAR <str>MC_STRING
%token <str>INTEGER <str>INTEGER_SIGNE <str>REAL <str>CHAR <str>STRING 

%type <str>Type
%type <str>Valeur
%type <str>ValNum
%type <str>ExprAr
%type <str>MembreDroit
%type <str>Produit

%left MC_EQ MC_LT MC_GT MC_LE MC_GE MC_NE
%left PLUS MOINS
%left MUL DIV


%start S

%%

S : EnTete BlocDeclaration BlocInstructions  { printf("Syntaxe correcte");   ajouterq("","","","");    YYACCEPT; }
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

ExprAr :  ExprAr PLUS ExprAr 		{	itoa(n,ns,10); strcpy(temp,"temp"); strcat(temp,ns); n++;
										ajouterq("+",$1,$3,temp); 
										strcpy($$, temp);
									}  
        | ExprAr MOINS ExprAr 		{	itoa(n,ns,10); strcpy(temp,"temp"); strcat(temp,ns); n++;
										ajouterq("-",$1,$3,temp); 
										strcpy($$, temp);    }
        | ExprAr MUL ExprAr 		{	itoa(n,ns,10); strcpy(temp,"temp"); strcat(temp,ns); n++;
										ajouterq("*",$1,$3,temp); 
										strcpy($$, temp);	}
		| ExprAr DIV ExprAr 	{ 	
									if(atof($3)==0) {
										printf("Ligne %d:%d  Erreur semantique: division par zero\n",line, column);
										exit(0);
									}
									else{ 
										itoa(n,ns,10); strcpy(temp,"temp"); strcat(temp,ns); n++;
										ajouterq("/",$1,$3,temp);
										strcpy($$, temp);
									}
								}
		| ValNum { $$ = $1; } 
		;

ValNum :  IDF 	{ 
					exist($1); comparerType(getType($1),"REAL"); 
					$$ = $1; 
					
				} 
         | INTEGER {$$ = $1;} 
         | INTEGER_SIGNE {$$ = $1;}
		 | REAL {$$ = $1;}
		 ;

// #### Expression Logique

ExprL : ExprAr OperateurL ExprAr { 
									saveqcL = qc; 

									switch(op){
										case 1: ajouterq("BE","",$1,$3); break;        //jump si vrai
										case 2: ajouterq("BGE","",$1,$3); break;
										case 3: ajouterq("BG","",$1,$3); break;
										case 4: ajouterq("BLE","",$1,$3); break;
										case 5: ajouterq("BL","",$1,$3); break;
										case 6: ajouterq("BNE","",$1,$3); break;
									}
									strcpy(tempL,"tempL");         // tempL = "tempL"
									itoa(nL,ns,10); nL++;		   //  ns = string(nL)
									strcat(tempL,ns);			   // tempL = tempL + ns
									empilerL(tempL);				
									ajouterq("=","0","",tempL);    
									saveqcL2 = qc;
									ajouterq("BR","","",""); 
									itoa(qc,buf,10);
									ajourq(saveqcL, 2, buf);
									ajouterq("=","1","",tempL);
									itoa(qc,buf,10);
									ajourq(saveqcL2 ,2,buf);
									};

OperateurL : MC_EQ {op=1;}
       | MC_GE {op=2;}
	   | MC_GT {op=3;}
	   | MC_LE {op=4;}
	   | MC_LT {op=5;}
	   | MC_NE {op=6;}
	   ;


// ##### AFFECTATION

Affectation : IDF AFFECTATION MembreDroit POINTVIRGULE {	
															exist($1); // vérifie l'existance l'IDF dans la TS															
															if(isConst($1)) {
																printf("Erreur semantique : changement de valeur d'une constante !");
																exit(0);
															}
															comparerType(getType($1),type); // compare les types de l'idf avec celui du membre droit
															ajouterq("=",$3,"",$1);
														};

MembreDroit : ExprAr {strcpy(type, "REAL"); $$ = $1;}
              | Produit {strcpy(type,"REAL"); $$ = $1;}
              | CHAR {strcpy(type, "CHAR"); $$ = $1;}
              | STRING	{strcpy(type, "STRING"); $$ = $1;}
              ;

Produit : MC_PROD PARANTHESE_OUVRANTE ListeProduit PARANTHESE_FERMANTE{ $$ = "fermetagueule"};

ListeProduit : ExprAr
        | ListeProduit VIRGULE ExprAr;

// ##### BOUCLE

Boucle : TempBoucle2 MC_EXECUTE ACCOLADE_OUVRANTE ListeInstructions ACCOLADE_FERMANTE POINTVIRGULE{
													save_bzWHILE = depilerQC();
													save_bzWHILE1 = depilerQC();
													itoa(save_bzWHILE1,buf,10);
													ajouterq("BR",buf,"","");
													itoa(qc,buf,10);
													ajourq(save_bzWHILE, 2, buf);
};

TempBoucle2 : TempBoucle1 ExprL {
								strcpy(valL,depilerL());
								save_bzWHILE = qc;
								empilerQC(qc);
								ajouterq("BZ","",valL,"");
							};

TempBoucle1 : MC_WHILE {
	empilerQC(qc);
	save_bzWHILE1=qc;
}

// ##### Controle

Controle : TempControle2 MC_OTHERWISE ListeInstructions POINTVIRGULE {
																		itoa(qc,buf,10); 
																		
																		save_brIF = depilerQC();
																		ajourq(save_brIF, 2, buf);
																	};

TempControle2 : TempControle1 MC_DO ListeInstructions {
														save_bzIF = depilerQC();
														empilerQC(qc);
														ajouterq("BR","","","");
														itoa(qc,buf,10);
														ajourq(save_bzIF, 2, buf);
													};

TempControle1 : MC_WHEN ExprL {
								strcpy(valL,depilerL());
								empilerQC(qc);
								ajouterq("BZ","",valL,"");
							};



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
	exit(0);
}
