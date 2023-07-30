function gr -d 'Convenience function for changing or printing the git root dir.'
  if not set git_dir (git rev-parse --show-toplevel)
    echo 'Not in git directory!'
    return -1
  end

  # Prints out root dir if in command substitution
  if status -c
    echo "$git_dir"
    return
  end

  set path "$git_dir/$argv[1]"
  if test ! -d "$path"
    echo "$path does not exist!"
    return -1
  end

  cd "$path"
end

