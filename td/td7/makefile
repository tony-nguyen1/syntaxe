calc : calc.y calc.l
	@echo debut $(YACC)-compil : calc.y
	$(YACC) $(YACCFLAGS) calc.y
	@echo debut $(LEX)-compil : calc.l
	$(LEX) calc.l
	@echo debut compil c avec edition de liens
	$(CC) -g -Wall -o calc y.tab.c lex.yy.c -lm # lib math
	@echo fin compil : vous pouvez executer calc