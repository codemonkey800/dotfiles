function __setup_autoenv --on-variable PWD
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
    while test $path != /
      if test -f $path/$env_filename
        set env_script $path/$env_filename
        break
      end

      set path (dirname $path)
    end
  end

  if test $env_script != ''
    # echo "Using env script $env_script"
    source $env_script
  end
end

__setup_autoenv

function __setup_nvm_auto_use --on-variable PWD
    set -l nvmrc_path ""
    set -l dir $PWD

    while test "$dir" != "/"
        if test -f "$dir/.nvmrc"
            set nvmrc_path "$dir/.nvmrc"
            break
        end
        set dir (dirname $dir)
    end

    if test -z "$nvmrc_path"
        return
    end

    set -l nvmrc_version (string trim (cat $nvmrc_path))

    if test "$nvmrc_path" = "$__NVM_LAST_NVMRC_PATH" \
    -a "$nvmrc_version" = "$__NVM_LAST_NVMRC_VERSION"
        return
    end

    nvm use $nvmrc_version
    set -g __NVM_LAST_NVMRC_PATH $nvmrc_path
    set -g __NVM_LAST_NVMRC_VERSION $nvmrc_version
end

__setup_nvm_auto_use

