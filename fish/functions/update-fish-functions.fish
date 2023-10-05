function update-fish-functions -d 'Commands related to my fish setup'
  pushd ~/.config/fish/functions
    echo 'Linking fish functions:'

    ln -svf $DOTFILES/fish/functions/* $PWD \
      | string replace $PWD/ '' \
      | string replace $DOTFILES/ '' \
      | sed 's/^/  /'

    echo

    echo 'Cleaning broken links:'
    for f in $PWD/*
      if not test -e $f
        rm -v $f \
          | string replace $PWD/ '' \
          | sed 's/^/  /'
      end
    end
  popd
end
