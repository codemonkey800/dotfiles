set -gx EDITOR /usr/bin/nvim
set -gx PAGER /usr/bin/less
set -gx LESS '-R'
set -gx LESSOPEN '|pygmentize -g %s'
set -gx LANG en_US.UTF-8
set -gx VIRTUAL_ENV_DISABLE_PROMPT 1
set -gx USR_LOCAL /usr/local/bin /usr/local/sbin
set -gx ANDROID_HOME /opt/android-sdk
set -gx ANDROID $ANDROID_HOME/tools $ANDROID_HOME/platform-tools
set -gx PATH $PATH $USR_LOCAL $ANDROID

