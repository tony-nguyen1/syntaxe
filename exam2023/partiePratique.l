%{ /* partiePratique.l */
/* ZONE DE DEFINITION (OPTIONNELLE) */
/* ZONE DES REGLES apres le double pourcent (OBLIGATOIRE) */
 //"/*"([^*]|\**[^*/])*\*+\/ { return 349; } 
#define LITF 401
#define OP 402

union {
    float f;
    char c;
} yyval;
%}
%option noyywrap
%%
[0-9]+|[0-9]*'.'[0-9]+|[0-9]+'.'[0-9]* { yyval.f=atoi(yytext); printf("    yyval.f=%f\n",yyval.f); return LITF; } // exemple 111  .111    111.
['+''-''*''/'] { yyval.c=yytext; printf("   yyval.c=%s, taille=%i\n", yytext, sizeof(yytext));  return OP; }
[ \t]
%%
/* ZONE DES FONCTIONS C */

int jeton; float sexp(float); float eexp();

#define AVANCER {jeton=yylex(); printf("...yytext=%s\n", yytext);}
#define ERREUR_SYNTAXE {printf("\nMot non reconnu : erreur de syntaxe"); exit(1);} 

float eexp() {
    printf("eexp()");
    if (jeton == LITF) {
        float gauche = yyval.f;
        AVANCER
        return sexp(gauche);
    } else {
        ERREUR_SYNTAXE
    }
}

float sexp(float f) {
    printf("sexp(%f)\n", f);
    if (jeton == LITF) {
        // printf("reconnaisance second LITF\n");
        float droite = eexp();//yyval.f;

        printf("yyval.c = %c\n", yyval.c);
        AVANCER
        if (jeton != OP) {ERREUR_SYNTAXE}
        printf("reconnaisance jeton OP\n");
        printf("yyval.c = %c\n", yyval.c);
        if (yytext == "+") {
            float result;
            result = f+yyval.f;
            printf("result = %f\n", result);
            return sexp(f+yyval.f);
        }
    } else {
        return f;
    }
}
int main()
{
    int j; 
    char *invite="Saisissez un(des) mot(s) matchant a(b+c)?|bd suivi de EOF (CTRL-D) SVP : ";
    printf("%s\n",invite);
    AVANCER
    printf("eexp() = %f\n",eexp());
    
    return 0;
}