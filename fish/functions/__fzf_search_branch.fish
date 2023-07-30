function __fzf_search_branch -d 'Finds branch from current git repo'
  if g s &> /dev/null
    set branch (
      g b -a \
        # Remove indent
        | string replace -ar '^  ' '' \
        # Remove asterisk from current branch
        | string replace -a '* ' '' \
        # Remove prefix for remote branches
        | string replace -a 'remotes/origin/' '' \
        # Remove arrows pointing to other branches
        | string replace -ar -- '-> .*' '' \
        # Sort and remove duplicates
        | sort -u \
        | fzf
      )

    if test $status -eq 0
      commandline --insert $branch
    end
  else
    echo "$PWD is not a git repo"
    commandline --function repaint
  end

  commandline --function repaint
end
