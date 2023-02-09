%{ /* analflex.l */
/* ZONE DE DEFINITION (OPTIONNELLE) */
/* ZONE DES REGLES apres le double pourcent (OBLIGATOIRE) */
%}
%option noyywrap
%%
^[ \t]*\n { return 300; /* Les lignes blanches */ }
^[ \t]* { return 301; /* Les espaces ou tab en début de lignes */ }
[ \t]+$ { return 302; /* Les espaces ou tab en fin de lignes */ }
[ \t]{2,} { return 303; /* Les espaces ou tabs entre les mots */ }
\t { return 304; }
%%
/* ZONE DES FONCTIONS C */
int main()
{
    int j; 
    // char *invite="Saisissez un(des) mot(s) matchant a(b+c)?|bd suivi de EOF (CTRL-D) SVP : ";
    // printf("%s",invite);
    while ((j=yylex())!=0) {
        if (j==300 || j==301 || j==302) {
            // do nothing
        } else if (j==303 || j==304) {
            printf(" ");
        }
        else {
            printf("%s",yytext);
        }
    }

    return 0;
}


/* 
^[ \t] { return 303;  Supprime les tabs/espace au début }
*/