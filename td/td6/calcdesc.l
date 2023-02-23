%{ /* analflex.l */
/* ZONE DE DEFINITION (OPTIONNELLE) */
/* ZONE DES REGLES apres le double pourcent (OBLIGATOIRE) */
 //"/*"([^*]|\**[^*/])*\*+\/ { return 349; } 
%}
%option noyywrap
%%
0|([1-9][0-9]*\.|0\.|\.[0-9])[0-9]* { return 333; } /* Lf */
"+" { return 300; }
"*" { return 301; }
%%
/* ZONE DES FONCTIONS C */
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
                             /* les macros sont des blocs : pas de ';' apres */
#define AVANCER {jeton=yylex();numcar++;}
//#define AVANCER {jeton=getchar();numcar++;}
#define TEST_AVANCE(prevu) {if (jeton==(prevu)) AVANCER else ERREUR_SYNTAXE}
#define ERREUR_SYNTAXE {printf("\nMot non reconnu : erreur de syntaxe \
au caractère numéro %d \n",numcar); exit(1);} 

int E(void);int R(int);int T(void);int S(int);float F(void); /* déclars */

int jeton;                       /* caractère courant du flot d'entrée */
int numcar=0;                    /* numero du caractère courant (jeton) */

int E(void){
  int x = T();                          /* regle : E->TR */
  return R(x);
}
int R(int left){
  if (jeton=='+') {             /* regle : R->+TR */
    AVANCER
    int x = T();
    return R(left+x);
  }
  else return left;                        /* regle : R->epsilon */
}
int T(void){
  int x = F();
  return S(x);                          /* regle : T->FS */
}
int S(int left){
  if (jeton=='*') {             /* regle : S->*FS */
    AVANCER
    int x = F();
    return S(left*x);
  }
  else return left;                        /* regle : S->epsilon */
}
float F(void){
  if (jeton=='(') {             /* regle : F->(E) */
    AVANCER
    int x = E();
    TEST_AVANCE(')')
    return x;
  }
  else 
    printf("On regarde si c'est un float ? \n");
    if (jeton==333)
    //if (isdigit(jeton))         /* regle : F->0|1|...|9 */
      { 
        printf("C'est un flottant \n");
        int j = jeton; 
        printf("j=%i \n",j);
        printf("j=%s \n",yytext);
        printf("long =%f \n", (float) atol(yytext));
        AVANCER
        return (float) atol(yytext);
        // return (j - '0');
      }
    else ERREUR_SYNTAXE
}
int main(void){                 /* Fonction principale */
  AVANCER			/* initialiser jeton sur le premier car */
  printf("%d",E());                         /* axiome */
  if (jeton==EOF)               /* expression reconnue et rien après */
    printf("\nMot reconnu\n"); 
  else ERREUR_SYNTAXE           /* expression reconnue mais il reste des car */

  // int j=yylex();
  // printf("\nJeton : %i; de lexeme %s \n",j,yytext);

  return 0;
}