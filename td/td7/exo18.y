%{
/* calc.y */
#include <math.h>
/* vrai si erreur sémantique : */
int errSemantiq=0;

/* division par 0 */
#define DIVPAR0 1

/* logarithme d'un négatif */
#define LOGNEG 2

#define YYSTYPE double
int yylex(void);void yyerror(char *s);
%}

/* définition des jetons */
%token LITFLOT SIN COS EXP LN PI QUIT HELP

/* traitement des priorités */
%left '+' '-'
%left '*' '/' '%'
%right MOINSUNAIRE
%right '^'
%%
liste : {/* chaine vide sur fin de fichier Ctrl-D */ }
      | liste ligne {}
      ;

ligne : '\n' {/* ligne vide : expression vide*/}
      | error '\n' {yyerrok; /*après la fin de ligne */}
      | expr '\n' { 
        if (!errSemantiq) printf("Résultat : %10.2f\n",$1); /* 10 car dont 2 décimales */
        else if (errSemantiq==DIVPARO) {
            printf("Erreur sémantique : division par 0 !\n");
            errSemantiq=0 /* RAZ */
        } else {
            printf("Erreur sémantique : logarithme d'un négatif ou nul !\n");
            errSemantiq=0; /* RAZ */
        }
       }
*/ }
:
|
;
:
{/* chaine vide sur fin de fichier Ctrl-D */ }
liste ligne {}