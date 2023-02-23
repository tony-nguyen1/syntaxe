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
#define TEST_AVANCE(prevu) {if (jeton==(prevu)) AVANCER else ERREUR_SYNTAXE}
#define ERREUR_SYNTAXE {printf("\nMot non reconnu : erreur de syntaxe \
au caractère numéro %d \n",numcar); exit(1);} 

int E(void);int R(int);int T(void);int S(int);int F(void); /* déclars */

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
int F(void){
  if (jeton=='(') {             /* regle : F->(E) */
    AVANCER
    int x = E();
    TEST_AVANCE(')')
    return x;
  }
  else 
    if (isdigit(jeton))         /* regle : F->0|1|...|9 */
      { int j = jeton; 
        AVANCER
      return (j - '0');}
    else ERREUR_SYNTAXE
}
int main(void){                 /* Fonction principale */
  AVANCER			/* initialiser jeton sur le premier car */
  printf("%d",E());                         /* axiome */
  if (jeton==EOF)               /* expression reconnue et rien après */
    printf("\nMot reconnu\n"); 
  else ERREUR_SYNTAXE           /* expression reconnue mais il reste des car */
  return 0;
}
