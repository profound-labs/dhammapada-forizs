FILE=book.main

LATEX=lualatex
BIBTEX=bibtex

LATEX_OPTS=-interaction=nonstopmode -halt-on-error

all: document

document: $(FILE).pdf

$(FILE).pdf: $(FILE).tex
	$(LATEX) $(LATEX_OPTS) $(FILE).tex;

again:
	$(LATEX) $(LATEX_OPTS) $(FILE).tex;

view:
	evince $(FILE).pdf &

cover-front:
	$(LATEX) $(LATEX_OPTS) cover_front.tex

clean:
	+rm -fv $(FILE).{dvi,ps,pdf,aux,log,bbl,blg}

