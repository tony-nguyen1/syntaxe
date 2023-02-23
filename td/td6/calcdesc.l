%{ /* analflex.l */
/* ZONE DE DEFINITION (OPTIONNELLE) */
/* ZONE DES REGLES apres le double pourcent (OBLIGATOIRE) */
 //"/*"([^*]|\**[^*/])*\*+\/ { return 349; } 
%}
%option noyywrap
%%
[0-9]*|([1-9][0-9]*\.|0\.|\.[0-9])[0-9]* { return 333; } /* Lf */
"+" { return 300; }
"*" { return 301; }
"/" { return 302; }
"-" { return 303; }
"^" { return 304; }

\n { return -1; }
%%
/* ZONE DES FONCTIONS C */
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <math.h>
                             /* les macros sont des blocs : pas de ';' apres */
#define AVANCER {jeton=yylex();numcar++;printf("jeton=%i\n",jeton);}
//#define AVANCER {jeton=getchar();numcar++;}
#define TEST_AVANCE(prevu) {if (jeton==(prevu)) AVANCER else ERREUR_SYNTAXE}
#define ERREUR_SYNTAXE {printf("\nMot non reconnu : erreur de syntaxe \
au caractère numéro %d \n",numcar); exit(1);} 

float E(void);float R(float);float T(void);float S(float);float F(void); float C(void); float G(void); /* déclars */

int jeton;                       /* caractère courant du flot d'entrée */
int numcar=0;                    /* numero du caractère courant (jeton) */

float E(void){
  printf("E() \n");
  float x = T();                          /* regle : E->TR */
  return R(x);
}
float R(float left){
  printf("R() \n");
  printf("On regarde si y a un plus ou un - ? \n");
  if (jeton==300) {             /* regle : R->+TR */
    printf("C'est un plus \n");
    AVANCER
    float x = T();
    printf("total = %f \n", left+x);
    return R(left+x);
  } else if (jeton==303) {
    printf("C'est un moins \n");
    AVANCER
    float x = T();
    printf("total = %f \n", left+x);
    return R(left-x);
  }
  else {                        /* regle : R->epsilon */
    printf("Il n'y pas de plus. \n");
    return left;
  }
}
float T(void){
  printf("T() \n");
  float x = F();
  printf("x = %f \n", x);
  return S(x);                          /* regle : T->FS */
}
float S(float left){
  printf("S(%f) \n", left);
  printf("On regarde si c'est un * ? \n");
  if (jeton==301) {             /* regle : S->*FS */
    printf("J'ai vu un * \n");
    AVANCER
    float x = F();
    return S(left*x);
  } else if (jeton==302) {
    printf("J'ai vu un / \n");
    AVANCER
    float x = F();
    return S(left/x);
  }
  else {
    printf("C'est pas un *. \n");
    return left;
  }                        /* regle : S->epsilon */
}
float F(void){
  printf("F() \n");
  if (jeton=='(') {             /* regle : F->(E) */
    AVANCER
    float x = E();
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
        printf("text=%s \n",yytext);
        char* errCheck;
        // printf("strtol = %f \n",  strtod(yytext, &errCheck));
        float f = strtod(yytext, &errCheck);
        printf("long = %f \n",  f);
        AVANCER
        return f;
        // return (j - '0');
      }
    else ERREUR_SYNTAXE
}
float C(float base) {
  printf("C() \n");
  if (jeton==304) {
    float exposant = C(G());
    return pow(base,exposant);
  } else { return base; }
}
/* TODO
- Modifier F
- Modifier G
 */
int main(void){                 /* Fonction principale */
  AVANCER			/* initialiser jeton sur le premier car */
  printf("E()=%f\n",E());                         /* axiome */
  if (jeton==-1)               /* expression reconnue et rien après */
    printf("\nMot reconnu\n"); 
  else {           /* expression reconnue mais il reste des car */
    printf("Il reste des car. \n");
    ERREUR_SYNTAXE
  }
  // int j=yylex();
  // printf("\nJeton : %i; de lexeme %s \n",j,yytext);

  return 0;
}

//tout les mots d'une grammaire ont un arbre de dérivatiton
// un mot de la grammaire a un arbre de dérivation dont les feuilles sont des character terminaux partant de l'axiome avec des symboles non terminaux(en cours de construction)
