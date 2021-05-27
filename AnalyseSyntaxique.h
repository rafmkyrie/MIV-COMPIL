%{
    
    
%}

%token MC_CODE MC_START MC_END MC_INTEGER MC_REAL MC_CHAR MC_STRING MC_CONST MC_PROD MC_WHILE MC_EXECUTE MC_WHEN MC_DO MC_OTHERWISE MC_EQ MC_LT MC_GT MC_LE MC_GE MC_NE DOLLAR PLUS MOINS MUL DIV AFFECTATION VIRGULE POINTVIRGULE PARANTHESE_OUVRANTE PARANTHESE_FERMANTE ACCOLADE_OUVRANTE ACCOLADE_FERMANTE INTEGER INTEGER_SIGNE REAL CHAR STRING IDF


%left Plus Moins
%left MUL DIV 
%left MC_EQ MC_LT MC_GT MC_LE MC_GE MC_NE

%start S

%%

S : EnTete BlocDeclaration BlocInstructions  {printf("Syntaxe correcte");      YYACCEPT;}
;   

EnTete : MC_CODE IDF {}
;

// #####################    BLOC DE DECLARATION

BlocDecaration :    DecCst BlocDec
			|	DecVar BlocDec
			|
			;

DecCst : CONST Type IDF AFFECTATION Valeur POINTVIRGULE {} ;

Type : MC_INTEGER {}
        | MC_REAL {}
	    | MC_CHAR {}
	    | MC_STRING {}
	    ;

Valeur : CHAR {}
      | STRING  {}
	  | REAL {}
	  | INTEGER {}
      | INTEGER_SIGNE {}
	  ;

DecVar : Type ListeIdf POINTVIRGULE {}
        ;

ListeIdf : IDF  {}
         | ListeIdf VIRGULE IDF {}
		 ;


// #####################    BLOC DES INSTRUCTIONS

BlocInstr : MC_START ListeInstructions MC_END {};

ListeInstructions : Instruction ListeInstructions
             |
			 ;

Instruction : Affectation 
       | Boucle 
	   | Controle
	   ;

// #### Expression Arithmétique

ExprAr :  ExprAr PLUS ExprAr 		{	}  
        | ExprAr MOINS ExprAr 		{	}
        | ExprAr MUL ExprAr 		{	}
		| ExprAr DIV ExprAr 	{   }
		| ValNum { } 
		;

ValNum :  IDF {}
         | INTEGER {} 
         | INTEGER_SIGNE {}
		 | REAL {}
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

Affectation : IDF AFFECTATION MembreDroit POINTVIRGULE;

MembreDroit : ExprAr {}
              | Produit {}
              | CHAR {}
              | STRING	{}
              ;

Produit : MC_PROD PARANTHESE_OUVRANTE ListeProduit PARANTHESE_FERMANTE;

ListeProduit : ExprAr
        | ListeProduit VIRGULE ExprAr;

// ##### BOUCLE

Boucle : MC_WHILE ExprL MC_EXECUTE ACCOLADE_OUVRANTE ListeInstructions ACCOLADE_FERMANTE POINTVIRGULE

// ##### Controle

Controle : MC_WHEN ExprL MC_DO ListeInstructions MC_OTHERWISE ListeInstructions;



%%

main(){
    yyparse();
}
yywrap()
{}