# Editor and pager stuff
set -gx TERM xterm-256color
set -gx EDITOR (which nvim)
set -gx PAGER (which less)

# Less stuff
set -gx LESS "-R"
set -gx LESSOPEN "|pygmentize -g %s"

# Fzf stuff
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

# Misc stuff
set -gx SRC $HOME/.local/src
set -gx LANG en_US.UTF-8
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

# PATH stuff
if test -d $HOME/.local/bin
    set -gx PATH $PATH $HOME/.local/bin
end

if test (uname) = Linux
    set -gx USR_LOCAL /usr/local/bin /usr/local/sbin ^ /dev/null
    for i in 1 2
        set -gx USR_LOCAL $USR_LOCAL (find $USR_LOCAL[$i] -type l -not -xtype l -o -type d)
    end

    set -gx JAVA_HOME /usr/lib/jvm/default ^ /dev/null
    set -gx ANDROID_HOME /opt/android-sdk ^ /dev/null
    set -gx ANDROID $ANDROID_HOME/tools $ANDROID_HOME/platform-tools ^ /dev/null
    set -gx PATH $PATH $USR_LOCAL $ANDROID $JAVA_HOME/bin ^ /dev/null
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
