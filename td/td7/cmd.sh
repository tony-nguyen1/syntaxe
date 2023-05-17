bison -d calc.y
flex ./calc.l
gcc -Wall -o calc calc.tab.c lex.yy.c -lm