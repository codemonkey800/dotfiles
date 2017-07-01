function update -d 'Runs various updates on my Arch system.'
# Run only on Arch Linux
  if not lsb_release -d | grep -q 'Arch Linux'
    echo 'This script can only be run on Arch Linux!'
    exit -1
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

# Update atom packages
  for x in apm{,-beta}
    if type -q $x
      eval $x upgrade --no-confirm
    end
  end

# Update pacman packages from official and aur
  yaourt -Syua --force --noconfirm
end
