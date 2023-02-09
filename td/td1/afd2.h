/**
 * @file afd2.h
 * @brief Définition d'un AFD du langage C
 * @author Michel Meynard
 */
#define EINIT 0
#define ESEP 1
#define ES 2
#define ESS 3
#define ECOML 4
#define ECOM 5
#define ESE 6
#define ESEE 7
#define EZERO 8
#define EP 9
#define EENT 10
#define EFLOAT 11
#define EI 12
#define EIF 13
#define EID 14
#define NBETAT 15


int TRANS[NBETAT][256];		/* table de transition : état suivant */
int JETON[NBETAT];		/* jeton (1-32000) ou non final (0) ? */


/** construit un ensemble de transitions de ed à ef pour un intervale de char
*@param ed l'état de départ
*@param ef l'état final
*@param cd char de début
*@param cf char de fin
*/
void classe(int ed, int ef, int cd, int cf){
  for (int c=cd; c<=cf; c++){
    TRANS[ed][c]=ef;
  }
}


void creerAfd(){			/* Construction de l'AFD */
  int i;int j;			/* variables locales */
  for (i=0;i<NBETAT;i++){
    for(j=0;j<256;j++) TRANS[i][j]=-1; /* init vide */
    JETON[i]=0;			/* init tous états non finaux */
  }
  
  // les séparateurs
  TRANS[EINIT]['\t']=ESEP;
  TRANS[EINIT][' ']=ESEP;
  TRANS[EINIT]['\n']=ESEP;
  TRANS[ESEP]['\t']=ESEP;
  TRANS[ESEP][' ']=ESEP;
  TRANS[ESEP]['\n']=ESEP;
  JETON[ESEP]=-1;

  // un commentaire avec double slash
  TRANS[EINIT]['/']=ES;
  TRANS[ES]['/']=ESS;
  for (int i = 0; i<256; i++)
    TRANS[ESS][i]=ESS;
  TRANS[ESS]['\n']=ECOML;
  JETON[ECOML]=-1;


  //un commentaire avec /**/
  TRANS[ES]['*']=ESE;
  for (int i = 0; i<256; i++)
    TRANS[ESE][i]=ESE;
  TRANS[ESE]['*']=ESEE;

  for (int i = 0; i<256; i++)
    TRANS[ESEE][i]=ESE;
  TRANS[ESEE]['*']=ESEE;
  TRANS[ESEE]['/']=ECOM;
  JETON[ECOM]=-1;

  //les nombres
  TRANS[EINIT]['.']=EP;
  TRANS[EINIT]['0']=EZERO;
  TRANS[EZERO]['.']=EFLOAT;
  classe(EP, EFLOAT, '0', '9');
  classe(EINIT, EENT, '1', '9');
  classe(EENT, EENT, '0', '9');
  classe(EFLOAT, EFLOAT, '0', '9');
  TRANS[EENT]['.'] = EFLOAT;
  JETON[EENT]=303;
  JETON[EFLOAT]=304;
  JETON[EZERO]=303;

  // le if
  TRANS[EINIT]['i']=EI;
  TRANS[EI]['f']=EIF;
  JETON[EIF]=302;
  

  // les identificateurs
  classe(EINIT, EID, 'a', 'h');
  classe(EINIT, EID, 'j', 'z');
  classe(EINIT, EID, 'A', 'Z');
  TRANS[EINIT]['_']=EID;

  classe(EI, EID, 'a', 'e');
  classe(EI, EID, 'g', 'z');
  classe(EI, EID, 'A', 'Z');
  classe(EI, EID, '0', '9');
  TRANS[EI]['_']=EID;
  

  classe(EIF, EID, 'a', 'z');
  classe(EIF, EID, 'A', 'Z');
  classe(EIF, EID, '0', '9');
  TRANS[EIF]['_']=EID;

  classe(EID, EID, 'a', 'z');
  classe(EID, EID, 'A', 'Z');
  classe(EID, EID, '0', '9');
  TRANS[EIF]['_']=EID;

  JETON[EI] = JETON[EID]= 301;

} 