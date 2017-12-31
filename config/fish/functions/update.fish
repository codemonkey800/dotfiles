function update -d 'Runs various updates on my Arch system.'
  if test (count $argv) -gt 0
    if contains -- -h $argv; or contains -- --help $argv
      echo 'Usage: update [tmp-dir]'
      echo
      echo 'Arguments:'
      echo '  tmp-dir - Specify to use alternative directory to $TMPDIR for yaourt.'
      return
    end
  end

  set tmp_dir
  if test (count $argv) -gt 0
    mkdir -vp $argv[1]
    set tmp_dir $argv[1]
  end

  # Update pacman db
  sudo reflector \
    --verbose \
    --threads (nproc) \
    --sort score \
    --save /etc/pacman.d/mirrorlist \
    --country US \
    --fastest 10

  # Update pkgfile definitions
  sudo pkgfile -u

  # Update fisher packages and re-link fish functions from $DOTFILES
  fisher up
  and ln -svf $DOTFILES/config/fish/functions/* ~/etc/fish/functions/
  fish_update_completions

  # Update atom packages
  for x in apm{,-beta}
    if type -qf $x
      eval $x upgrade --no-confirm
    end
  end

  # Update pacman packages from official and aur
  env TMPDIR=$tmp_dir yaourt -Syua --force --noconfirm
end

