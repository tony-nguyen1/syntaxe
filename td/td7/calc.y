%{ /* calc.y */
#include <math.h>
#include <stdio.h>
int errSemantiq=0; /* vrai si erreur sémantique :*/
#define DIVPAR0 1 /* division par 0 */
#define LOGNEG 2 /* logarithme d'un négatif */
#define YYSTYPE double /* type de la valeur sémantique qu'on récupère */
int yylex(void);void yyerror(char *s);
/* terminaux : vrai, faux       non-terminaux : E T
E -> E & E | E|E | E -> E | E==E | E^E | !E | (E) | T
T -> vrai | faux
 */
%}
/* définition des jetons */
%token LITFLOT SIN COS EXP LN PI QUIT HELP AND OR IMP EQU OUX NO T B
/* traitement des priorités */
%left '+' '-'
%left '*' '/' '%'
%left AND OR EQ OUX NO 
%right MOINSUNAIRE
%right '^'
%right IMP
%%
liste : {/* chaine vide sur fin de fichier Ctrl-D */ }
| liste ligne {}
;

ligne : '\n' {/* ligne vide : expression vide */ }
| error '\n' {yyerrok; /* après la fin deligne */ }
| expr '\n' {if (!errSemantiq) 
				printf("Résultat : %10.2f\n",$1); /* 10 car dont 2décimales */
			else if (errSemantiq==DIVPAR0){
				printf("Erreur sémantique : division par 0 !\n");
				errSemantiq=0; /* RAZ */
			}
			else {
				printf("Erreur sémantique : logarithme d'un négatif ou nul !\n");
				errSemantiq=0; /* RAZ */
			}
			}
| QUIT '\n' {return 0; /* fin de yyparse */ }
| HELP '\n' {
	printf(" Aide de la calculette\n");
	printf(" =====================\n");
	printf("Taper une expression constituée de nombres,d'opérations,\n");
	printf(" de fonctions, de constantes, de parenthèsespuis taper <Entrée> \n");
	printf("Ou taper une commande suivie de <Entrée>\n\n");
	printf("Syntaxe des nombres : - optionnel, suivi dechiffres, \n");
	printf(" suivi d'un . optionnel, suivi de chiffres\n");
	printf("Opérations infixes : + - * / ^ %% (modulo) \n");
	printf("Fonctions prédéfinies : sin(x) cos(x) exp(x)ln(x)\n");
	printf("Constantes prédéfinies : pi\n");
	printf("Commandes : exit ou quit pour quitter lacalculette\n");
	printf(" aide ou help ou \? pour affichercette aide\n");
	}
;
expr : '(' expr ')' {$$ = $2;}
| expr '+' expr {$$ = $1 + $3;}
| expr '-' expr {$$ = $1 - $3;}
| expr '*' expr {$$ = $1 * $3;}
| expr '/' expr {if ($3!=0)
					$$ = $1 / $3;
				else
					errSemantiq=DIVPAR0; /* par défaut $$=$1 */
				}
| expr '^' expr {$$ = pow($1,$3);}
| expr '%' expr { if ($3!=0) $$ = fmod($1,$3);
				  else errSemantiq=DIVPAR0; /* par défaut $$=$1 */
				}
| '-' expr %prec MOINSUNAIRE {$$ = - $2;}
| SIN '(' expr ')'{$$ = sin ( M_PI/180*$3 );}
| COS '(' expr ')'{$$ = cos ( M_PI/180*$3 );}
| EXP '(' expr ')'{$$ = exp($3);}
| LN '(' expr ')' {	if ($3>0) $$ = log($3);
					else errSemantiq=LOGNEG; /* $$=$1 ... */
				  }
| PI {$$ = M_PI;}
| LITFLOT {$$ = $1;}
;
%%
void yyerror(char *s) {fprintf(stderr,"%s\n",s);}
int main(void){int yydebug=0; return yyparse();}