
%{
#include <stdlib.h>/* pour double atof(char *) */
#include <stdio.h>
#include "arbin.h"
//#define YYSTYPE arbin
int yylex(void);void yyerror(char *s);
%}

%union {
    Arbin typeArbin; //type des non terminaux
    int typeInt; // type des terminaux /jetons
}
%token<typeInt> SYMBOLE /* definition des jetons */
%type<typeArbin> s t e f /* définition des non terminaux */

%%
ligne : error '\n' {yyerrok; exit(0);} /* error */
      | s '\n' { ab_afficher($1); }
      ;

s : s '|' e { $$=ab_construire('|', $1, $3); /* la racine c'est |, arbre gauche c'est $1 s, arbre droite c'est $3 e */ }
  | e {$$=$1;}
  ;

e : e t {$$=ab_construire('.',$1,$2); }
  | t {$$=$1;}
  ;

t : t '*' { $$=ab_construire('*',$1,NULL); }
  | f {$$=$1;}
  ;

f : '(' s ')' {$$=$2;}
  | SYMBOLE { $$=ab_construire($1, ab_creer(),ab_creer()); /* arbre ac 2 arbres vide */}
  ;
%%
int yylex(void) {
    // int c;
    // while(((c=getchar())==' ') || (c=='\t'));
    // return c;
    int i=getchar();
    if ((i>='a' && i<='z')||i=='@'||i=='0') { yylval.typeInt=i;/* val sementique */ return SYMBOLE; }
    else return i;
}
void yyerror(char *s) { fprintf(stderr,"%s\n",s); }
int main() {
    printf("Veuillez entrer une expression régulière S.V.P. : ");
    return yyparse();
}