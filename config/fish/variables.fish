# helper functions
function __add_to_path
    for arg in $argv
        if not contains $arg $PATH
            if string match -q '/*' $arg; and not test -d $arg
                return -1
            end
            set -gx PATH $PATH $arg ^ /dev/null
        end
    end
end

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
set -gx MANPAGER "$EDITOR -c 'setf man' -c 'runtime! macros/less.vim' -"
set -gx PAGER "$EDITOR -c 'runtime! macros/less.vim' -c AnsiEsc -"

# user installed software
set -gx SOFTWARE_HOME ~/share/software

# android stuff
set -gx ANDROID_HOME $SOFTWARE_HOME/android/sdk

# PATH stuff
__add_to_path (find $DOTFILES/bin -type d)
__add_to_path $ANDROID_HOME/tools
__add_to_path $ANDROID_HOME/platform-tools

# FZF stuff
if type -q fzf
    set -gx FZF_TMUX 1
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

