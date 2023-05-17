%{ /* analflex.l */
/* ZONE DE DEFINITION (OPTIONNELLE) */
/* ZONE DES REGLES apres le double pourcent (OBLIGATOIRE) */
    int nb=0;
%}
%option noyywrap
%%
\n { nb++; return 300; /* Les lignes blanches */ }
%%
/* ZONE DES FONCTIONS C */
int main()
{
    int j; 
    // char *invite="Saisissez un(des) mot(s) matchant a(b+c)?|bd suivi de EOF (CTRL-D) SVP : ";
    // printf("%s",invite);
    while ((j=yylex())!=0) {
        /* if (j==300 || j==301 || j==302) {
            // do nothing
        } else if (j==303 || j==304) {
            printf(" ");
        }
        else {
            printf("%s",yytext);
        } */
    }

    printf("%i",nb);

    return 0;
}


/* 
^[ \t] { return 303;  Supprime les tabs/espace au début }
*/