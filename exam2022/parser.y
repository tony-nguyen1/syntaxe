%{

%}

%token ID INT FLOAT 

%%
decl : type ID '(' lparam ')' ';'
;
lparam : param rparam 
    |
;
rparam : ',' param rparam
    |
;
param : type ID
;
type : INT
    | FLOAT
;
%%