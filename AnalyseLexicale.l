/*Chiboub Abderraouf Nassim*/
/*Mouffok Tayeb Abderraouf*/
%{
#include<stdlib.h>
#include<stdio.h>
#include<string.h>
#include "AnalyseSyntaxique.tab.h"

void inserermc();
void inserervc();
void inserersep();

int line = 1;
int column = 1;
extern YYSTYPE yylval;

%}

Dollar ("$")
Plus ("+")
Moins ("-")
Mul ("*")
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
IDF {LettreMaj}({Lettre}|{Chiffre})*



%%

"CODE"  { inserermc(yytext,"MC"); column = column + strlen(yytext); printf("MC_code "); return MC_CODE;}
"START" { inserermc(yytext,"MC"); column = column + strlen(yytext); printf("MC_start "); return MC_START; }
"END."  { inserermc(yytext,"MC"); column = column + strlen(yytext); printf("MC_end "); return MC_END; }

"INTEGER" { inserermc(yytext,"MC"); yylval.str=strdup(yytext); column = column + strlen(yytext); printf("MC_integer "); return MC_INTEGER; }
"REAL"    { inserermc(yytext,"MC"); yylval.str=strdup(yytext); column = column + strlen(yytext); printf("MC_real "); return MC_REAL; }
"CHAR"    { inserermc(yytext,"MC"); yylval.str=strdup(yytext); column = column + strlen(yytext); printf("MC_char "); return MC_CHAR; }
"STRING"  { inserermc(yytext,"MC"); yylval.str=strdup(yytext); column = column + strlen(yytext); printf("MC_string "); return MC_STRING; }
"CONST"   { inserermc(yytext,"MC"); yylval.str=strdup(yytext); column = column + strlen(yytext); printf("MC_const "); return MC_CONST; } 

"PROD"      { inserermc(yytext,"MC"); column = column + strlen(yytext); printf("MC_prod "); return MC_PROD; }
"WHILE"     { inserermc(yytext,"MC"); column = column + strlen(yytext); printf("MC_while "); return MC_WHILE; }
"EXECUTE"   { inserermc(yytext,"MC"); column = column + strlen(yytext); printf("MC_execute "); return MC_EXECUTE; }
"WHEN"      { inserermc(yytext,"MC"); column = column + strlen(yytext); printf("MC_when "); return MC_WHEN; }
"DO"        { inserermc(yytext,"MC"); column = column + strlen(yytext); printf("MC_do "); return MC_DO; }
"OTHERWISE" { inserermc(yytext,"MC"); column = column + strlen(yytext); printf("MC_otherwise "); return MC_OTHERWISE; }

"EQ"   { inserermc(yytext,"MC"); column = column + strlen(yytext); printf("MC_eq "); return MC_EQ; } 
"LT"   { inserermc(yytext,"MC"); column = column + strlen(yytext); printf("MC_lt "); return MC_LT; } 
"GT"   { inserermc(yytext,"MC"); column = column + strlen(yytext); printf("MC_gt "); return MC_GT; } 
"LE"   { inserermc(yytext,"MC"); column = column + strlen(yytext); printf("MC_le "); return MC_LE; } 
"GE"   { inserermc(yytext,"MC"); column = column + strlen(yytext); printf("MC_ge "); return MC_GE; } 
"NE"   { inserermc(yytext,"MC"); column = column + strlen(yytext); printf("MC_ne "); return MC_NE; } 

{Dollar} { inserersep(yytext,"SEP"); column = column + strlen(yytext); printf("Dollar "); return DOLLAR; } 
{Plus}   { inserersep(yytext,"SEP"); column = column + strlen(yytext); printf("Plus "); return PLUS; } 
{Moins}  { inserersep(yytext,"SEP"); column = column + strlen(yytext); printf("Moins "); return MOINS; } 
{Mul}   { inserersep(yytext,"SEP"); column = column + strlen(yytext); printf("Mul "); return MUL; } 
{Div}    { inserersep(yytext,"SEP"); column = column + strlen(yytext); printf("Div "); return DIV; } 

{Affectation}         { inserersep(yytext,"SEP"); column = column + strlen(yytext); printf("Affectation "); return AFFECTATION; } 
{Virgule}             { inserersep(yytext,"SEP"); column = column + strlen(yytext); printf("Virgule "); return VIRGULE; } 
{PointVirgule}        { inserersep(yytext,"SEP"); column = column + strlen(yytext); printf("PointVirgule "); return POINTVIRGULE; } 
{ParantheseOuvrante}  { inserersep(yytext,"SEP"); column = column + strlen(yytext); printf("ParantheseOuvrante "); return PARANTHESE_OUVRANTE; } 
{ParantheseFermante}  { inserersep(yytext,"SEP"); column = column + strlen(yytext); printf("ParantheseFermante "); return PARANTHESE_FERMANTE; } 
{AccoladeOuvrante}    { inserersep(yytext,"SEP"); column = column + strlen(yytext); printf("AccoladeOuvrante "); return ACCOLADE_OUVRANTE; } 
{AccoladeFermante}    { inserersep(yytext,"SEP"); column = column + strlen(yytext); printf("AccoladeFermante "); return ACCOLADE_FERMANTE; } 

{Integer} { column = column + strlen(yytext); yylval.str=strdup(yytext); printf("Integer "); return INTEGER; } 
{IntegerSigne} { column = column + strlen(yytext); yylval.str=strdup(yytext); printf("IntegerSigne "); return INTEGER_SIGNE; } 
{Real} { column = column + strlen(yytext); yylval.str=strdup(yytext); printf("Real "); return REAL; } 
{Char} { column = column + strlen(yytext); yylval.str=strdup(yytext); printf("Char "); return CHAR; } 
{String} { column = column + strlen(yytext); yylval.str=strdup(yytext); printf("String "); return STRING; } 

{Commentaire} { column = column + strlen(yytext); printf("Commentaire "); }
{IDF} { 
       if(strlen(yytext)>20){
              printf("Erreur Lexicale [%d:%d] - Identificateur \"%s\" trop long (max. 20 caractères)\n", line, column, yytext);
       }
       else{
              column = column + strlen(yytext);
              printf("%s ", yytext);
              yylval.str=strdup(yytext);
              return IDF; 
       }
       } 
	
[ \t] { column = column + strlen(yytext); printf(" "); }
"\n"   { line++; column=1; printf("\n"); }

.     { printf("Erreur Lexicale [%d:%d] - Entité non reconnue : %s \n", line, column, yytext); }  


%%


