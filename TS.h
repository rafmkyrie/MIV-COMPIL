#ifndef TS_H_INCLUDED
#define TS_H_INCLUDED
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

extern int line, column;


typedef struct enregistrement_var_const{ 
   char nom[20];
   char code[20];
   char type[10];
   char val[40]; 
              }enregistrement_var_const;
			 
typedef struct elt1varconst elt1varconst;
struct elt1varconst{
	         enregistrement_var_const e1;
		     struct	 elt1varconst *suivant;
	              };
				  
typedef struct enregistrement_mc_sep{
           char nom[20];
	       char type[10];
                   }enregistrement_mc_sep;
				   
typedef struct elt2mc elt2mc;
struct elt2mc{
    enregistrement_mc_sep e2;
	struct elt2mc *suivant;
              };

typedef struct elt3sep elt3sep;
 struct elt3sep{
   enregistrement_mc_sep e3;
   struct elt3sep* suivant;
};


typedef struct teteTab1 teteTab1;
struct teteTab1{
	elt1varconst *premier;
};

typedef struct teteTab2 teteTab2;
struct teteTab2{
	elt2mc *premier;
};

typedef struct teteTab3 teteTab3;
struct teteTab3{
	elt3sep *premier;
};


struct teteTab1 TAB1;
struct teteTab2 TAB2;
struct teteTab3 TAB3;

typedef struct eltpile eltpile;
struct eltpile{
	char temp[10];
	eltpile* suivant;
};

typedef struct pile pile;
struct pile{
	eltpile* tetepile;
};

struct pile pile1;				//temp expression Arithmétique
struct pile pile2;				//temp expression Logique

void empilerA(char* temp){
	eltpile *p = malloc(sizeof(eltpile));
	strcpy(p->temp,temp);
	p->suivant = pile1.tetepile;
	pile1.tetepile = p;
}

char* depilerA(){
	eltpile* p;
	
	if(pile1.tetepile!=NULL){
		p = pile1.tetepile;
		pile1.tetepile=p->suivant;
	}
	else printf("Ligne %d:%d  Depilement d'une pile vide\n",line,column);
	
	return p->temp;
}

void empilerL(char* temp){
	eltpile *p = malloc(sizeof(eltpile));
	strcpy(p->temp,temp);
	p->suivant = pile2.tetepile;
	pile2.tetepile = p;
}

char* depilerL(){
	eltpile* p;
	
	if(pile2.tetepile!=NULL){
		p = pile2.tetepile;
		pile2.tetepile=p->suivant;
	}
	else printf("Ligne %d:%d  Depilement d'une pile vide\n",line,column);
	
	return p->temp;
}

//*********************************************  AFFICHAGE DES TS  ******************************************************************************************************


void affichervc(){
	elt1varconst *a;
	a = TAB1.premier;
	printf("********************** TABLE DES VAR / CST **********************\n\n");
	printf("\tNom\t\t\tCode\t\t\tType\t\t\tVal\n\n");
	while(a!=NULL){
		printf("\t%s\t\t\t",a->e1.nom);
		printf("%s\t\t\t",a->e1.code);
		printf("%s\t\t\t",a->e1.type);
		printf("%s\n\n",a->e1.val);
		a=a->suivant;
	}
}
	
	
void affichermc(){
	elt2mc *a;
	a = TAB2.premier;
	printf("********************** TABLE DES MOTS CLES **********************\n\n");
	printf("\tNom\t\t\tType\n\n");
	while(a!=NULL){
		printf("\t%s\t\t\t",a->e2.nom);
		printf("%s\n\n",a->e2.type);
		a=a->suivant;
	}
}

void affichersep(){
	elt3sep *a;
	a = TAB3.premier;
	printf("********************** TABLE DES SEPARATEURS **********************\n\n");
	printf("\tNom\t\t\tType\n\n");
	while(a!=NULL){
		printf("\t%s\t\t\t",a->e3.nom);
		printf("%s\n\n",a->e3.type);
		a=a->suivant;
	}
}






//***********************************************************************************************************************************************************

elt1varconst* recherchervc(char* nom){
	elt1varconst *a;
	a = TAB1.premier;
	
	
	while(a!=NULL){
		if(strcmp(a->e1.nom,nom)==0) return a;
		else a=a->suivant;
	}
	
	return a;
}

void inserervc(char nom[],char code[],char type[],char val[]){
	
	elt1varconst *a;
	a = recherchervc(nom);
	
	if((a==NULL) || (a->e1.type==NULL)){
		enregistrement_var_const temp;
		struct elt1varconst *p = malloc(sizeof(elt1varconst));
		strcpy(temp.nom,nom);
		strcpy(temp.type,type);
		strcpy(temp.code,code);
		strcpy(temp.val,val);
		p->e1=temp;
		p->suivant=TAB1.premier;
		TAB1.premier=p;
	}
	else{
		printf("Ligne %d:%d  Double declaration detectee!\n",line,column);
		exit(0);
	}
}

void inserertype(char type[]){
	elt1varconst *a;
	a = TAB1.premier;
	
	
	while(a!=NULL){
		if(strcmp(a->e1.type, "")==0){
			strcpy(a->e1.type, type);
			a=a->suivant;
		}
		else return;
	}
	return;
}

char* getType(char* nom){
	struct elt1varconst *a;
	a = recherchervc(nom);
	if(a!=NULL){
		return a->e1.type;
	}
	else printf("Ligne %d:%d  IDF non déclaré!\n",line,column); exit(0);
}

char* getVal(char* nom){
	struct elt1varconst *a;
	a = recherchervc(nom);
	if(a!=NULL){
		return a->e1.val;
	}
	else printf("Ligne %d:%d  IDF non déclaré!\n",line,column); exit(0);
}

int isConst(char* nom){
	struct elt1varconst *a;
	a = recherchervc(nom);
	if(a!=NULL){
		return (strcmp(a->e1.code, "CONST")==0);
	}
	else {
		printf("Ligne %d:%d  IDF non déclaré!\n",line,column); 
		exit(0);
	}
}


elt2mc* recherchermc(char* nom){
	elt2mc *a;
	a = TAB2.premier;
	
	while(a!=NULL){
		if(strcmp(a->e2.nom,nom)==0) return a;
		else a=a->suivant;
	}
	
	return a;
}


void inserermc(char nom[],char type[]){
	
	elt2mc *a;
	a = recherchermc(nom);
	
	if(a==NULL){
		enregistrement_mc_sep temp2;
		elt2mc *p = malloc(sizeof(elt2mc));
		strcpy(temp2.nom,nom);
		strcpy(temp2.type,type);
		p->e2 = temp2;
		p->suivant = TAB2.premier;
		TAB2.premier = p;
	}
}

elt3sep* recherchersep(char* nom){
	elt3sep *a;
	a = TAB3.premier;
	
	while(a!=NULL){
		if(strcmp(a->e3.nom,nom)==0) return a;
		else a=a->suivant;
	}
	
	return a;
}


void inserersep(char nom[],char type[]){
	elt3sep *a;
	a = recherchersep(nom);
	
	if(a==NULL){
		enregistrement_mc_sep temp3;
		elt3sep *p = malloc(sizeof(elt3sep));
		strcpy(temp3.nom,nom);
		strcpy(temp3.type,type);
		p->e3 = temp3;
		p->suivant = TAB3.premier;
		TAB3.premier = p;
	}
	
}


int comparerType(char* type1, char* type2){
	printf("\n\ntype1 = %s    /   type2 = %s\n\n", type1, type2);
	if(strcmp(type1,type2)==0)return 0;
	else{
		if((strcmp(type1,"INTEGER")==0)&&(strcmp(type2, "REAL")==0)) return 0;
		else{if((strcmp(type1,"REAL")==0)&&(strcmp(type2, "INTEGER")==0)) return 0;
			else{printf("Ligne %d:%d  Erreur de compatibilité de types!\n",line,column);exit(0);}
		}
	}
}

void exist(char nom[]){
	struct elt1varconst *a;
	a = recherchervc(nom);
	
	if(a!=NULL) return;
	else{
		printf("Ligne %d:%d  Erreur : idf n'est pas declaré !\n",line,column);
		exit(0);
	}
}



//******************************************************************************************************************************************************************








//  QUADRUPLES

typedef struct qdr{
	char opr[100];
	char op1[100];
	char op2[100];
	char res[100];
}qdr;

qdr quad[1000];
int qc=0;

void ajouterq(char opr[],char op1[],char op2[],char res[])
{
	strcpy(quad[qc].opr,opr);
	strcpy(quad[qc].op1,op1);
	strcpy(quad[qc].op2,op2);
	strcpy(quad[qc].res,res);
	qc++;
}	

void ajourq(int qc,int i, char ch[]){
	switch(i){
		case 1: strcpy(quad[qc].opr,ch); break;
		case 2: strcpy(quad[qc].op1,ch); break;
		case 3: strcpy(quad[qc].op2,ch); break;
		case 4: strcpy(quad[qc].res,ch); break;
		default: printf("i = 1-4\n"); break;
	}
}

void afficherq(){
	printf("**********Affichage des quadruplets**********\n\n");
	printf("Num\tOpr\t\tOp1\t\tOp2\t\tRes\n");
	for(int i=0;i<qc;i++){
		printf("%d\t%s\t\t%s\t\t%s\t\t%s\n",i,quad[i].opr,quad[i].op1,quad[i].op2,quad[i].res);
	}
}

void affichertout(){
	affichervc();
	affichermc();
	affichersep();
	afficherq();
}



#endif //TS_H_INCLUDED