function clear-functions -d 'Erases a set of functions by namespace. Useful for locally nested helper functions.'
  if not set -q argv[1]
    echo 'Usage: clear-functions <namespace>'
    echo
    echo 'Arguments:'
    echo '  namespace - The namespace, usually prefixed by two underscores'
    echo
    echo 'Example:'
    echo '  Clears all functions under the __fish namespace.'
    echo '  Please never do this.'
    echo '  $ clear-functions __fish'
    return 0
  end

  set funcs (
    functions -a \
      | string split ',' \
      | grep -E "^$argv[1]"
  )

  if test (count $funcs) -gt 0
    for f in $funcs
      functions -e "$f"
    end
  else
    return -1
  end
end
