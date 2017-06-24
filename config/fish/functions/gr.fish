function gr -d 'Convenience function for changing or printing the git root dir.'
  if set git_dir (git rev-parse --show-toplevel)
    # Prints out root dir if in command substitution
    if status -c
      echo "$git_dir"
    else
      cd "$git_dir"
    end
  else
    echo 'Not in git directory!'
    return -1
  end
end

