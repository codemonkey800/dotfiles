FROM archlinux/base

# Needed for texlive-latexextra
RUN pacman --noconfirm -Sy grep

RUN pacman --noconfirm -S \
  make \
  texlive-core \
  texlive-latexextra

WORKDIR /resume
ENTRYPOINT [ "make" ]
