function setup-autoenv --on-variable PWD
  set -l path $PWD
  set -l env_filename '.env.fish'
  set -l env_script ''
  set -l is_git_repo (
    if g s &> /dev/null
      echo true
    else
      echo false
    end
  )

  if test -f $path/.env.fish
    set env_script $path/.env.fish
  end

  if test $env_script = '' -a $is_git_repo = true
    while test $path != / -a ! -d $path/.git
      if test -f $path/$env_filename
        set env_script $path/$env_filename
        break
      end

      set path (dirname $path)
    end
  end

  if test $env_script != ''
    echo "Using env script $env_script"
    source $env_script
  end
end
