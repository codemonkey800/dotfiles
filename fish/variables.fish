set -gx EDITOR /usr/bin/vim
set -gx PAGER /usr/bin/less
set -gx LESS '-R'
set -gx LESSOPEN '|pygmentize %s'
set -gx GTK_SCALE 2
set -gx LANG en_US.UTF-8
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1
set -gx USR_LOCAL /usr/local/bin /usr/local/sbin
set -gx ANDROID_HOME /opt/android-sdk
set -gx ANDROID $ANDROID_HOME/tools $ANDROID_HOME/platform-tools
set -gx PATH $PATH $USR_LOCAL $ANDROID

