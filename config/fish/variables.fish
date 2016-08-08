# Editor and pager stuff
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
        -fstype dev -o \
        -fstype proc \
    \\) -prune -o \
    -type d -print 2> /dev/null
"

set -gx FZF_CTRL_T_COMMAND "
    command find -L . \\( \
        -path '*/.git' -o \
        -path '*/.cache' -o \
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
set -gx LANG en_US.UTF-8
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1

# PATH stuff
if test (uname) = "Darwin"
    set -gx PATH $PATH $HOME/.local/bin
else
    set -gx USR_LOCAL /usr/local/bin /usr/local/sbin ^ /dev/null
    for i in 1 2
        set -gx USR_LOCAL $USR_LOCAL (find $USR_LOCAL[$i] -type l -not -xtype l -o -type d)
    end


    set -gx JAVA_HOME /usr/lib/jvm/default ^ /dev/null
    set -gx ANDROID_HOME /opt/android-sdk ^ /dev/null
    set -gx ANDROID $ANDROID_HOME/tools $ANDROID_HOME/platform-tools ^ /dev/null
    set -gx PATH $PATH $USR_LOCAL $ANDROID $JAVA_HOME/bin ^ /dev/null
end

