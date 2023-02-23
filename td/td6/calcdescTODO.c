/** @file analdesc.c        
 *@author Michel Meynard
 *@brief Analyse descendante récursive d'expression arithmétique
 *
 * Ce fichier contient un reconnaisseur d'expressions arithmétiques composée de 
 * littéraux entiers sur un car, des opérateurs +, * et du parenthésage ().
 * Remarque : soit rediriger en entrée un fichier, soit terminer par deux 
 * caractères EOF (Ctrl-D), un pour lancer la lecture, l'autre comme "vrai" EOF.
 */
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
                             /* les macros sont des blocs : pas de ';' apres */
#define AVANCER {jeton=getchar();numcar++;}
/* Demander le prochain token par lex */
#define TEST_AVANCE(prevu) {if (jeton==(prevu)) AVANCER else ERREUR_SYNTAXE}
#define ERREUR_SYNTAXE {printf("\nMot non reconnu : erreur de syntaxe \
au caractère numéro %d \n",numcar); exit(1);} 

void E(void);int R(void);int T(void);void S(void);void F(void); /* déclars */

int jeton;                       /* caractère courant du flot d'entrée */
int numcar=0;                    /* numero du caractère courant (jeton) */

/* 1 fct par fct nom-terminal */
int E(int i){
  int res = T();                          /* regle : E->TR */
  return R(res);
}
int R(int i){
  if (jeton=='+') {             /* regle : R->+TR */
    AVANCER
    T();
    R();
  }
  else ;                        /* regle : R->epsilon */
}
int T(void){
  F();
  S();
  return 0;                         /* regle : T->FS */
}
void S(void){
  if (jeton=='*') {             /* regle : S->*FS */
    AVANCER
    F();
    S();
  }
  else ;                        /* regle : S->epsilon */
}
void F(void){
  if (jeton=='(') {             /* regle : F->(E) */
    AVANCER
    E();
    TEST_AVANCE(')')
  }
  else 
    if (isdigit(jeton))         /* regle : F->0|1|...|9 */
      AVANCER
    else ERREUR_SYNTAXE
}
int main(void){                 /* Fonction principale */
  //AVANCER			/* initialiser jeton sur le premier car */
  E(atoi(jeton));                          /* axiome */
  if (jeton==EOF)               /* expression reconnue et rien après */
    printf("\nMot reconnu\n"); 
  else ERREUR_SYNTAXE           /* expression reconnue mais il reste des car */
  return 0;
}