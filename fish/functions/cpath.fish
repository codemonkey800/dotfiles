function cpath -d 'Copies the fully resolved path of the given argument to the clipboard.'
  if test (count $argv) -ne 1
    echo 'Usage: cpath <path>'
    return -1
  end

  set -l resolved (path resolve -- "$argv[1]")
  set -l copied false

  if test -n "$TMUX"
    tmux set-buffer -- "$resolved"
    set copied true
  end

  if type -q pbcopy
    printf '%s' "$resolved" | pbcopy
    set copied true
  end

  if test "$copied" = false
    echo 'Warning: no clipboard available (not in tmux and pbcopy not found)'
  end

  echo "$resolved"
end
