TEX = pdflatex
TEX_FLAGS = -interaction=nonstopmode -shell-escape

all: *.pdf

*.pdf: *.tex
	$(TEX) $(TEX_FLAGS) $?
	@mkdir -v build
	@mv -v $@ build

clean:
	@rm -vrf *.log *.aux
	@rm -vrf build

.PHONY: all clean

