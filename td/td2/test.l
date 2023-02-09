%{ /* analflex.l */
/* ZONE DE DEFINITION (OPTIONNELLE) */
/* ZONE DES REGLES apres le double pourcent (OBLIGATOIRE) */
 //"/*"([^*]|\**[^*/])*\*+\/ { return 349; } 
%}
/* cdt° exclusive */
%x STRING
%x COMMENTMULTILIGNES
%x ID
%option noyywrap
%%
if|then|throw|else { return 310; } /* Lkey */
0[0-7]* { return 300; } /* Lc8 */
0|[1-9][0-9]* { return 301; } /* Lc10 */
0x([0-9][A-F])+ { return 302; } /* Lc16 */
([a-z]|[A-Z])([a-z]|[A-Z]|[0-9]|_)* { return 303; } /* Lid */
0|([1-9][0-9]*\.|0\.|\.[0-9])[0-9]* { return 333; } /* Lf */
[\t\n ]+ { } /* Lsep  /unCharacter compte pour 1 pas 2*/
"//".*\n {/* commentaires sur une ligne */}
"/*" { BEGIN(COMMENTMULTILIGNES); }
<COMMENTMULTILIGNES>"*/" { BEGIN(INITIAL); }

.|\n {return -1; /* ret un jeton pour tout le reste */ }
%%
/* ZONE DES FONCTIONS C */
int main()
{
    int j; 
    char *invite="Saisissez un(des) mot(s) matchant a(b+c)?|bd suivi de EOF (CTRL-D) SVP : ";
    printf("%s",invite);
    while ((j=yylex())!=0) printf("\nJeton : %i; de lexeme %s \n%s",j,yytext,invite);

    return 0;
}