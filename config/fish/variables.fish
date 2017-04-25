# less stuff
set -gx LESS '-R'
set -gx LESSOPEN '|pygmentize -g %s'

# development environment
set -gx DIRENV_LOG_FORMAT
set -gx EDITOR (type -p nvim)
set -gx NVIM_LISTEN_ADDRESS /tmp/nvim-(whoami).socket
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

# GPG stuff
set -gx ENCRYPTION_KEY A1CE3226F4FDEFF5
set -gx GPG_TTY (tty)
set -gx SIGNING_KEY 3FCC32880193C153

# locale stuff
set -gx LANG en_US.UTF-8

# pager stuff
set -gx PAGER less

# PATH stuff
set -gx PATH $PATH ~/bin
set -gx PATH $PATH $DOTFILES/bin

# FZF stuff
if type -q fzf
    set -gx FZF_TMUX 1

    # set fzf find file command to use the_platinum_searcher if in git repo,
    # otherwise use find command
    # this includes hidden files and directories by default
    set -gx FZF_FIND_FILE_COMMAND '
        if git status > /dev/null ^&1
            set -l files (
                pt -g "" \
                   --hidden \
                   --global-gitignore \
                   --ignore .git \
                   ^ /dev/null
            )
            for f in $files
                echo $f
                dirname $f
            end | sort -fru
        else
            command find -L . \
                \\( -path "*/\\.git*" -o -fstype dev -o -fstype proc \\) -prune \
                -o -type f -print \
                -o -type d -print \
                -o -type l -print ^ /dev/null \
                | sed 1d | cut -b3-
        end
    '

    # set fzf cd command to use the_platinum_searcher if in git repo,
    # otherwise use find command
    set -gx FZF_CD_COMMAND '
        if git status > /dev/null ^&1
            set -l files (
                pt -g "" \
                   --global-gitignore \
                   --ignore .git \
                   ^ /dev/null
            )
            for f in $files
                set -l dir (dirname $f)
                test "$dir" != "."; and echo $dir
            end | sort -fru
        else
            command find -L . \
                \\( -path "*/\\.*" -o -fstype dev -o -fstype proc \\) -prune \
                -o -type d -print ^ /dev/null \
                | sed 1d | cut -b3-
        end
    '

    # set fzf cd with hidden command to use the platinum_searcher if in git repo,
    # otherwise use find command
    set -gx FZF_CD_WITH_HIDDEN_COMMAND '
        if git status > /dev/null ^&1
            set -l files (
                pt -fg "" \
                   --hidden \
                   --global-gitignore \
                   --ignore .git \
                   ^ /dev/null
            )
            for f in $files
                dirname $f
            end | sort -fru
        else
            command find -L . \
                \\( -path "*/\\.git*" -o -fstype dev -o -fstype proc \\) -prune \
                -o -type d -print ^ /dev/null \
                | sed 1d |  cut -b3-
        end
    '
end

