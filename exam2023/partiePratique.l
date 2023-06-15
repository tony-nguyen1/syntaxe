%{ /* partiePratique.l */
#include <math.h>
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
[0-9]+|[0-9]*\.[0-9]+|[0-9]+\.[0-9]* { yyval.f=atof(yytext); /* printf("    yyval.f=%f\n",yyval.f); */ return LITF; } // exemple 111  .111    111.
[+\-*/^] { /* printf("%s     %c\n",yytext, yyval.c); */ yyval.c=yytext; printf("%s     %c\n",yytext, yyval.c); return OP; }
[ \t] {}
%%
/* ZONE DES FONCTIONS C */

int jeton; float sexp(float); float eexp(); float customPow(float, float);

#define AVANCER {jeton=yylex(); printf("AVANCER    yytext=%s\n", yytext);}
#define ERREUR_SYNTAXE {printf("\nMot non reconnu : erreur de syntaxe"); exit(1);} 

float eexp() {
    printf("eexp()\n");
    if (jeton == LITF) {
        float gauche = yyval.f;
        AVANCER
        return sexp(gauche);
    } else {
        ERREUR_SYNTAXE
    }
}
int n = 0;
float sexp(float f) {
    n++;
    printf("sexp(%f)\n", f);
    if (jeton == LITF) {
        printf("ici\n");
        float droite = eexp();
        if (jeton != OP) {printf("oof %f %f\n", f, droite);ERREUR_SYNTAXE}
        float result;
        if (strcmp(yytext,"*")==0) {
            result = f*droite;
            printf("result : %f + %f = %f\n",f,droite, result);
        } else if (strcmp(yytext,"+")==0) {
            result = f+droite;
            printf("result : %f + %f = %f\n",f,droite, result);
        } else if (strcmp(yytext,"-")==0) {
            result = f-droite;
            printf("result : %f + %f = %f\n",f,droite, result);
        } else if (strcmp(yytext,"/")==0) {
            result = f/droite;
            printf("result : %f + %f = %f\n",f,droite, result);
        }  else if (strcmp(yytext,"^")==0) {
            result = customPow(f,droite); //f/droite;
            printf("result : %f ^ %f = %f\n",f,droite, result);
        }
        AVANCER
        return sexp(result);
    } else {
        printf("là %f\n", f);
        return f;
    }
}

float customPow(float f, float n) {
    if (n > 0) {
        return customPow(f,n-1)*f;
    } return 1;
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
// make lex.yy.c && make a.out && ./a.out < text.txt