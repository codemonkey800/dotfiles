TEX = pdflatex
TEX_FLAGS = -interaction=nonstopmode -shell-escape

all: build/resume.pdf

build/resume.pdf: resume.tex
	@mkdir -vp build
	$(TEX) $(TEX_FLAGS) -output-directory=build $<

clean:
	@rm -rfv build

.PHONY: all clean

