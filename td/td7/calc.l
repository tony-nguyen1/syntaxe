%{
    /* calc.l */
    #define YYSTYPE double
    /* ATTENTION AUX 2 MACROS dans lex et yacc */
    #include "calc.tab.h"
    /* JETONS crees par yacc et definition de yylval */
    #include <stdlib.h>
    /* pour double atof(char *) */
    #include <stdio.h>
    /* pour printf */
%}
vrai (vrai|true|1)
faux (vaux|false|0)
chiffre ([0-9])
entier ({chiffre}+)
%option noyywrap
%%
& { return(AND); }
\| { return(OR); }
-> { return(IMP); }
== { return(EQ); }
\^ { return(OUX); }
! { return(NO); }
vrai { return(T); }
faux { return(B); }


[ \t]+ {/* filtrer les blancs */ }
 /* laisser l'accolade à la ligne precedente */
{entier}|{entier}\.{chiffre}*|{chiffre}*\.{entier} { yylval=atof(yytext);return (LITFLOT); }
sin { return(SIN); }
cos { return(COS); }
exp { return(EXP); }
ln { return(LN); }
pi { return(PI); }
exit|quit { return (QUIT); }
aide|help|\? { return (HELP); }
.|\n { return yytext[0]; /* indispensable ! */ }
%%