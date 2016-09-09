TEX = pdflatex
TEX_FLAGS = -interaction=nonstopmode -shell-escape
PAPER = resume

all: $(PAPER).pdf

$(PAPER).pdf: $(PAPER).tex
	$(TEX) $(TEX_FLAGS) $?

clean:
	@rm -vrf *.log *.pdf *.aux

.PHONY: all clean

