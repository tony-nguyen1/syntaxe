/** @file a.c 
 * @brief analyseur récursif descendant construisant l’arbre abstrait 
 * correspondant à une expression régulière 
 * @author Oausi
*/

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include "../td5/arbin.h"
#define AVANCER {jeton=getchar();numcar++;}
#define TEST_AVANCE(prevu) {if (jeton==(prevu)) AVANCER else ERREUR_SYNTAXE}
#define ERREUR_SYNTAXE {printf("\nMot non reconnu; erreur de syntaxe \
au caractère numéro %d \n",numcar); exit(1);}
Arbin S();Arbin X(Arbin);Arbin E();Arbin R(Arbin);Arbin T();Arbin Y(Arbin);Arbin F();

int jeton; /* caractère courant du flot d'entrée */
int numcar=0; /* numero du caractère courant (jeton) */

Arbin S(){ // S->EX
    return X(E());
}

Arbin X(Arbin g){ // X->'|'EX|epsilon
    if (jeton==124) { // (char) 124 == '|' 
        Arbin d = E();
        return X(ab_construire('|',g,d));
    } else {
        return g;
    }
}

Arbin E(){ // E-> TR
    return R(T());
}

Arbin R(Arbin g){ // R->TR|epsilon
    // pour décider si on est dans le cas TR ou le cas epsilon, on regarde premiers(T)=premiers(F)={(,minuscule,@,0}
    //TODO
}

Arbin T(){ //T-> FY
    return Y(F());
}

Arbin Y(Arbin g){ // Y->*Y|epsilon
    if (jeton!=42) { 
        ab_construire(jeton, NULL, g);
    }
    else return NULL;
}

Arbin F(){ // F->(S)|@|0|a-z
    if (jeton<97 || jeton>122 || jeton==64 || jeton==48) { ERREUR_SYNTAXE }
    Arbin nouv = (Arbin) malloc(sizeof(Noeudbin)) ;
    nouv->val=jeton;
    nouv->fg=NULL;
    nouv->fd=NULL;
}

int main(){
    Arbin r;
    printf("entrer une exp reg : \n");
    AVANCER;
    r=S();//axiome
    if (jeton=='\n'){
        printf("mot reconnu dont l'arbre absrait est : \n");
        ab_afficher(r);
    } else{
        ERREUR_SYNTAXE;
    }
    return 0;
}