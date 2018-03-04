function get_missing
  set deps_file $argv[1]
  set globals ~/.config/yarn/global/node_modules

  test -f $deps_file
  or return

  set missing
  for dep in (cat $deps_file)
    test -d $globals/$dep
    and continue

    set missing $missing $dep
  end

  test (count $missing) -gt 0
  or return

  echo $missing
end

function print_missing
  set type $argv[1]
  set deps (string split ' ' "$argv[2]" | sort -u)

  echo "Missing $type Dependencies:"
  for dep in $deps
    echo "  $dep"
  end
end

function main
  set pkg $argv[1]
  set root $DOTFILES/bin/js

  set global_deps (get_missing $root/dependencies | string split ' ')
  set local_deps (get_missing $pkg/dependencies | string split ' ')

  test (count $global_deps) -gt 0 -o (count $local_deps) -gt 0
  or return

  test (count $global_deps) -gt 0
  and print_missing 'Global' "$global_deps"

  test (count $local_deps) -gt 0
  and print_missing 'Script' "$local_deps"

  echo

  command yarn global add $global_deps $local_deps

  clear
end

main $argv

