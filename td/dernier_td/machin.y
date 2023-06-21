%{

%}
%token INT FLOAT ID QUIT

%%
decl : type ID '(' lparam ')' ';' {};
lparam : param rparam {};
rparam : ',' param rparam {};
param : type ID {};
type : INT {}
    | FLOAT {};
%%
