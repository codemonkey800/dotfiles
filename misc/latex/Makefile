TEX = $(shell which pdflatex)
TEX_FLAGS = -interaction=nonstopmode -shell-escape

BUILD_DIR = build/
SRC_FILES = $(wildcard chapter*/*.tex)
OUT_FILES = $(SRC_FILES:%.tex=$(BUILD_DIR)/%.pdf)

all: $(OUT_FILES)
	@mkdir -vp $(BUILD_DIR)

$(BUILD_DIR)/%.pdf: %.tex
	@mkdir -vp $(dir $@)
	$(TEX) $(TEX_FLAGS) -output-directory=$(dir $<) $<
	@mv -v $(<:.tex=.pdf) $@

clean:
	@rm -rfv $(shell find -name "*.aux" -o -name "*.log" -o -name "*_minted")
	@rm -rfv $(BUILD_DIR)

.PHONY: all clean

