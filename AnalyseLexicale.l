%{
#include<stdlib.h>
#include<stdio.h>
#include<string.h>

//#include "TS.h"

extern int line=1;
extern int col=1;


%}

Dollar ("$")
Plus ("+")
Moins ("-")
Fois ("*")
Div ("/")

Affectation (":=")
PointVirgule (";")
ParantheseOuvrante ("(")
ParantheseFermante (")")
AccoladeOuvrante ("{")
AccoladeFermante ("}")

LettreMaj ([A-Z])
Lettre    ([a-zA-Z])
Chiffre   ([0-9])

Integer       ({Chiffre}+)
IntegerSigne  ([-+]Integer)
Real     ({Integer|IntegerSigne}"."{Integer})
Char 
String   (\"([^\\\"]|\\.)*\")

Commentaire ({Dollar}[^{Dollar}]*{Dollar})
IDF LettreMaj({Lettre}|{Chiffre})+



%%

"CODE"  { col = col + strlen(yytext);  return MC_code; }
"START" { col = col + strlen(yytext);  return MC_start; }
"END."  { col = col + strlen(yytext);  return MC_end; }

"INTEGER" { col = col + strlen(yytext);  return MC_integer; }
"REAL"    { col = col + strlen(yytext);  return MC_real; }
"CHAR"    { col = col + strlen(yytext);  return MC_char; }
"STRING"  { col = col + strlen(yytext);  return MC_string; }
"CONST"   { col = col + strlen(yytext);  return MC_const; }

"PROD"      { col = col + strlen(yytext);  return MC_prod; }
"WHILE"     { col = col + strlen(yytext);  return MC_while; }
"EXECUTE"   { col = col + strlen(yytext);  return MC_execute; }
"WHEN"      { col = col + strlen(yytext);  return MC_when; }
"DO"        { col = col + strlen(yytext);  return MC_do; }
"OTHERWISE" { col = col + strlen(yytext);  return MC_otherwise; }

"EQ"   { col = col + strlen(yytext);  return MC_eq; }
"LT"   { col = col + strlen(yytext);  return MC_lt; }
"GT"   { col = col + strlen(yytext);  return MC_gt; }
"LE"   { col = col + strlen(yytext);  return MC_le; }
"GE"   { col = col + strlen(yytext);  return MC_ge; }
"NE"   { col = col + strlen(yytext);  return MC_ne; }

{Dollar} { col = col + strlen(yytext);  return Dollar; }
{Plus}   { col = col + strlen(yytext);  return Plus; }
{Moins}  { col = col + strlen(yytext);  return Moins; }
{Fois}   { col = col + strlen(yytext);  return Fois; }
{Div}    { col = col + strlen(yytext);  return Div; }

{Affectation}         { col = col + strlen(yytext);  return Affectation; }
{PointVirgule}        { col = col + strlen(yytext);  return PointVirgule; }
{ParantheseOuvrante}  { col = col + strlen(yytext);  return ParantheseOuvrante; }
{ParantheseFermante}  { col = col + strlen(yytext);  return ParantheseFermante; }
{AccoladeOuvrante}    { col = col + strlen(yytext);  return AccoladeOuvrante; }
{AccoladeFermante}    { col = col + strlen(yytext);  return AccoladeFermante; }

{Commentaire} { col = col + strlen(yytext); }
{IDF} { col = col + strlen(yytext); 
       if(strlen(yytext)>20){
              yyerror("Erreur Lexicale [%d:%d] - Identificateur \"%s\" trop long (max. 20 caractères)\n", line, col, yytext);
       }
       return IDF; }
	
[ \t] { col = col + strlen(yytext); }
\\n   { line++; col=1; }

.     { yyerror("Erreur Lexicale [%d:%d] - Entité non reconnue : %s \n", line, col, yytext); }  


%%

int main(int argc, const char *argv[]){

	yyin = fopen("programme.txt", "r");
	if (yyin==NULL) {printf("ERROR \n");}
	else {yylex();}
	return 0;
	
}


int yywrap()
{return 0;}  
