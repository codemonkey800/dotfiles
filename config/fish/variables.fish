# Less stuff
setenv LESS '-R'
setenv LESSOPEN '|pygmentize -g %s'

# Development environment
setenv DIRENV_LOG_FORMAT
setenv DOTFILES ~/.local/src/misc/dotfiles
setenv EDITOR (which nvim)
setenv SRC ~/.local/src
setenv VIRTUAL_ENV_DISABLE_PROMPT 1

# GPG stuff
setenv ENCRYPTION_KEY A1CE3226F4FDEFF5
setenv SIGNING_KEY 3FCC32880193C153

# Locale stuff
setenv LANG en_US.UTF-8

# Pagerstuff
setenv MANPAGER "$EDITOR -c 'setf man' -c 'runtime! macros/less.vim' -"
setenv PAGER "$EDITOR -c 'runtime! macros/less.vim' -c AnsiEsc -"

# PATH stuff
mkdir -p ~/.local/bin
mkdir -p ~/.local/src/go/bin

setenv GOPATH ~/.local/src/go

function __add_to_path
    if not contains $argv[1] -- $PATH
        setenv PATH $PATH $argv[1]
    end
end

__add_to_path ~/.local/bin
__add_to_path $GOPATH/bin

# Fzf stuff
if exists fzf
    if exists tmux
        setenv FZF_TMUX 1
    end
end

# Color settings
setenv fish_color_autosuggestion 8a8a8a
setenv fish_color_command 005fd7
setenv fish_color_comment ff8700
setenv fish_color_cwd green
setenv fish_color_cwd_root red
setenv fish_color_end 00FF00
setenv fish_color_error FF0000
setenv fish_color_escape cyan
setenv fish_color_history_current cyan
setenv fish_color_host normal
setenv fish_color_match cyan
setenv fish_color_normal normal
setenv fish_color_operator cyan
setenv fish_color_param 00afff
setenv fish_color_quote 8700ff
setenv fish_color_redirection normal
setenv fish_color_search_match \x2d\x2dbackground\x3dpurple
setenv fish_color_selection \x2d\x2dbackground\x3dpurple
setenv fish_color_status red
setenv fish_color_user green
setenv fish_color_valid_path \x2d\x2dunderline
setenv fish_pager_color_completion normal
setenv fish_pager_color_description 555\x1eyellow
setenv fish_pager_color_prefix cyan
setenv fish_pager_color_progress cyan

