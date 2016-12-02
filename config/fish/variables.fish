# Less stuff
set -gx LESS "-R"
set -gx LESSOPEN "|pygmentize -g %s"

# Development environment
set -gx DIRENV_LOG_FORMAT ''
set -gx DOTFILES ~/.local/src/misc/dotfiles
set -gx EDITOR (which nvim)
set -gx SRC ~/.local/src
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

# Locale stuff
set -gx LANG en_US.UTF-8

# Pagerstuff
set -gx MANPAGER "$EDITOR -c 'setf man' -c 'runtime! macros/less.vim' -"
set -gx PAGER "$EDITOR -c 'runtime! macros/less.vim' -c AnsiEsc -"

# PATH stuff
mkdir -p ~/.local/bin
mkdir -p ~/.local/src/go/bin


set -gx GOPATH ~/.local/src/go

function __add_to_path
    if not contains $argv[1] -- $PATH
        set -gx PATH $PATH $argv[1]
    end
end

__add_to_path ~/.local/bin
__add_to_path $GOPATH/bin

# Fzf stuff
if exists fzf
    if exists tmux
        set -gx FZF_TMUX 1
    end

    set -gx FZF_ALT_C_COMMAND "
        command find -L . \\( \
            -path '*/.git' -o \
            -path '*/.cache' -o \
            -path '*/node_modules' -o \
            -path '*/build' -o \
            -path '*/_minted*' -o \
            -fstype dev -o \
            -fstype proc \
        \\) -prune -o \
        -type d -print 2> /dev/null
    "

    set -gx FZF_CTRL_T_COMMAND "
        command find -L . \\( \
            -path '*/.git' -o \
            -path '*/.cache' -o \
            -path '*/node_modules' -o \
            -path '*/build' -o \
            -path '*/_minted*' -o \
            -fstype dev -o \
            -fstype proc \
        \\) -prune -o \
        \\( \
            -type f -o \
            -type d -o \
            -type l \
        \\) -print 2> /dev/null
    "
end

# Color settings
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
