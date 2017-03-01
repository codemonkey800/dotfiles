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

# user installed software
set -gx SOFTWARE_HOME ~/share/software

# android stuff
set -gx ANDROID_HOME $SOFTWARE_HOME/android/sdk

# PATH stuff
set -gx PATH $PATH $DOTFILES/bin
set -gx PATH $PATH $ANDROID_HOME/platform-tools ^ /dev/null
set -gx PATH $PATH $ANDROID_HOME/tools ^ /dev/null

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

# color settings
set -gx fish_color_autosuggestion 8a8a8a
set -gx fish_color_command 005fd7
set -gx fish_color_comment ff8700
set -gx fish_color_cwd green
set -gx fish_color_cwd_root red
set -gx fish_color_end 00FF00
set -gx fish_color_error FF0000
set -gx fish_color_escape cyan
set -gx fish_color_history_current cyan
set -gx fish_color_host normal
set -gx fish_color_match cyan
set -gx fish_color_normal normal
set -gx fish_color_operator cyan
set -gx fish_color_param 00afff
set -gx fish_color_quote 8700ff
set -gx fish_color_redirection normal
set -gx fish_color_search_match \x2d\x2dbackground\x3dpurple
set -gx fish_color_selection \x2d\x2dbackground\x3dpurple
set -gx fish_color_status red
set -gx fish_color_user green
set -gx fish_color_valid_path \x2d\x2dunderline
set -gx fish_pager_color_completion normal
set -gx fish_pager_color_description 555\x1eyellow
set -gx fish_pager_color_prefix cyan
set -gx fish_pager_color_progress cyan

