%{
#include<stdlib.h>
#include<stdio.h>
#include<string.h>

//#include "TS.h"

int line=1;
int col=1;


%}

Dollar ("$")
Plus ("+")
Moins ("-")
Fois ("*")
Div ("/")

Affectation (":=")
Virgule (",")
PointVirgule (";")
ParantheseOuvrante ("(")
ParantheseFermante (")")
AccoladeOuvrante ("{")
AccoladeFermante ("}")

LettreMaj ([A-Z])
Lettre    ([a-zA-Z])
Chiffre   ([0-9])

Integer       ({Chiffre}+)
Real   ([-+]?{Integer}"."{Integer})
IntegerSigne  ([-+]{Integer})
Char   (\'{Lettre}\')
String   (\"([^\\\"]|\\.)*\")

Commentaire ({Dollar}[^{Dollar}]*{Dollar})
IDF {LettreMaj}({Lettre}|{Chiffre})+



%%

"CODE"  { col = col + strlen(yytext); printf("MC_code "); return MC_CODE; }
"START" { col = col + strlen(yytext); printf("MC_start "); return MC_START; }
"END."  { col = col + strlen(yytext); printf("MC_end "); return MC_END; }

"INTEGER" { col = col + strlen(yytext); printf("MC_integer "); return MC_INTEGER; }
"REAL"    { col = col + strlen(yytext); printf("MC_real "); return MC_REAL; }
"CHAR"    { col = col + strlen(yytext); printf("MC_char "); return MC_CHAR; }
"STRING"  { col = col + strlen(yytext); printf("MC_string "); return MC_STRING; }
"CONST"   { col = col + strlen(yytext); printf("MC_const "); return MC_CONST; } 

"PROD"      { col = col + strlen(yytext); printf("MC_prod "); return MC_PROD; }
"WHILE"     { col = col + strlen(yytext); printf("MC_while "); return MC_WHILE; }
"EXECUTE"   { col = col + strlen(yytext); printf("MC_execute "); return MC_EXECUTE; }
"WHEN"      { col = col + strlen(yytext); printf("MC_when "); return MC_WHEN; }
"DO"        { col = col + strlen(yytext); printf("MC_do "); return MC_DO; }
"OTHERWISE" { col = col + strlen(yytext); printf("MC_otherwise "); return MC_OTHERWISE; }

"EQ"   { col = col + strlen(yytext); printf("MC_eq "); return MC_EQ; } 
"LT"   { col = col + strlen(yytext); printf("MC_lt "); return MC_LT; } 
"GT"   { col = col + strlen(yytext); printf("MC_gt "); return MC_GT; } 
"LE"   { col = col + strlen(yytext); printf("MC_le "); return MC_LE; } 
"GE"   { col = col + strlen(yytext); printf("MC_ge "); return MC_GE; } 
"NE"   { col = col + strlen(yytext); printf("MC_ne "); return MC_NE; } 

{Dollar} { col = col + strlen(yytext); printf("Dollar "); return DOLLAR; } 
{Plus}   { col = col + strlen(yytext); printf("Plus "); return PLUS; } 
{Moins}  { col = col + strlen(yytext); printf("Moins "); return MOINS; } 
{Mul}   { col = col + strlen(yytext); printf("Mul "); return MUL; } 
{Div}    { col = col + strlen(yytext); printf("Div "); return DIV; } 

{Affectation}         { col = col + strlen(yytext); printf("Affectation "); return AFFECTATION; } 
{Virgule}             { col = col + strlen(yytext); printf("Virgule "); return VIRGULE; } 
{PointVirgule}        { col = col + strlen(yytext); printf("PointVirgule "); return POINTVIRGULE; } 
{ParantheseOuvrante}  { col = col + strlen(yytext); printf("ParantheseOuvrante "); return PARANTHESE_OUVRANTE; } 
{ParantheseFermante}  { col = col + strlen(yytext); printf("ParantheseFermante "); return PARANTHESE_FERMANTE; } 
{AccoladeOuvrante}    { col = col + strlen(yytext); printf("AccoladeOuvrante "); return ACCOLADE_OUVRANTE; } 
{AccoladeFermante}    { col = col + strlen(yytext); printf("AccoladeFermante "); return ACCOLADE_FERMANTE; } 

{Integer} { col = col + strlen(yytext); printf("Integer "); return INTEGER; } 
{IntegerSigne} { col = col + strlen(yytext); printf("IntegerSigne "); return INTEGER_SIGNE; } 
{Real} { col = col + strlen(yytext); printf("Real "); return REAL; } 
{Char} { col = col + strlen(yytext); printf("Char "); return CHAR; } 
{String} { col = col + strlen(yytext); printf("String "); return STRING; } 

{Commentaire} { col = col + strlen(yytext); printf("Commentaire "); }
{IDF} { col = col + strlen(yytext); 
       if(strlen(yytext)>20){
              printf("Erreur Lexicale [%d:%d] - Identificateur \"%s\" trop long (max. 20 caractères)\n", line, col, yytext);
       }
       printf(" ");
       return IDF; 
       } 
	
[ \t] { col = col + strlen(yytext); printf(" "); }
\\n   { line++; col=1; printf("\n"); }

.     { printf("Erreur Lexicale [%d:%d] - Entité non reconnue : %s \n", line, col, yytext); }  


%%

int main(int argc, const char *argv[]){

	yyin = fopen("exemple.txt", "r");
	if (yyin==NULL) {printf("ERROR \n");}
	else {yylex();}
	return 0;
	
}


int yywrap()
{return 0;}
