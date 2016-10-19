TEX = pdflatex
TEX_FLAGS = -interaction=nonstopmode -shell-escape
SRC_FILES = $(wildcard *.tex)
OUT_FILES = $(SRC_FILES:.tex=.pdf)

all: $(OUT_FILES)

$(OUT_FILES): $(SRC_FILES)
	$(TEX) $(TEX_FLAGS) $?
	@mkdir -pv build
	@mv -v $@ build

clean:
	@rm -vrf *.log *.aux *.pdf _minted-*
	@rm -vrf build

.PHONY: all clean

