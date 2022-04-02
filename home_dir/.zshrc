#################################################################################################
# Awesome Tips For Terminal!                                                                    #
# https://medium.com/@ivanaugustobd/your-terminal-can-be-much-much-more-productive-5256424658e8 #
#################################################################################################

alias echo-black="echo '\033[0;30m'"
alias echo-dark-gray="echo '\033[1;30m'"
alias echo-red="echo '\033[0;31m'"
alias echo-light-red="echo '\033[1;31m'"
alias echo-green="echo '\033[0;32m'"
alias echo-light-green="echo '\033[1;32m'"
alias echo-brown/orange="echo '\033[0;33m'"
alias echo-yellow="echo '\033[1;33m'"
alias echo-blue="echo '\033[0;34m'"
alias echo-light-blue="echo '\033[1;34m'"
alias echo-purple="echo '\033[0;35m'"
alias echo-light-purple="echo '\033[1;35m'"
alias echo-cyan="echo '\033[0;36m'"
alias echo-light-cyan="echo '\033[1;36m'"
alias echo-light-gray="echo '\033[0;37m'"
alias echo-white="echo '\033[1;37m'"

######################
echo-cyan "Initializing..."
######################

export PATH=$HOME/bin:/usr/local/bin:$HOME/thatguyrussell/.local/bin:$PATH
 
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
    source /etc/profile.d/vte-2.91.sh
fi

if command -v python3 &> /dev/null; then
    alias python="python3"
    alias pip="pip3"
fi
 
alias edit="code $HOME/.zshrc"
alias update="source $HOME/.zshrc"
 
setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_BEEP

###########################################
echo-cyan "Ensuring Core Tools are Installed..."
###########################################

# Brew

if ! command -v brew &> /dev/null; then
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh
fi

export PATH="/opt/homebrew/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"
export HOMEBREW_NO_ANALYTICS=1

echo ""
brew cu --all -q >/dev/null

# Pip
if ! command -v pip &> /dev/null; then
    sudo python -m ensurepip --upgrade
fi
pip install --upgrade pip >/dev/null 2>&1

# C++
if ! command -v gcc &> /dev/null; then
    brew install gcc
fi

# Ruby
if ! command -v ruby &> /dev/null; then
    brew install ruby
fi
export PATH="/opt/homebrew/lib/ruby/gems/3.1.0/bin:$PATH"

# Make
if ! command -v make &> /dev/null; then
    brew install make
fi

# NPM
if ! command -v npm &> /dev/null; then
    brew install npm
fi
export PATH="$PATH:/opt/homebrew/lib/node_modules/npm/bin"

# Gradle
if ! command -v gradle &> /dev/null; then
    brew install gradle
fi

# Git
alias edit_git_config="code $HOME/.gitconfig"
alias edit_work_git_config="code $HOME/.gitconfig-work"

if ! command -v diff-so-fancy &> /dev/null; then
    brew install diff-so-fancy
fi

# Go
if ! command -v go &> /dev/null; then
    brew install go
fi
export GOPATH=$HOME/go
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

# Helm
if ! command -v go &> /dev/null; then
    brew install helm
fi

#####################
# Oh My Zsh         #
#                   #
# https://ohmyz.sh/ #
#####################
source $HOME/.ohmyzsh_config
 
###########################################
# Colorls                                 #
#                                         #
# https://github.com/athityakumar/colorls #
###########################################
if ! command -v colorls &> /dev/null; then
    sudo pip install colorls
fi

source $(dirname $(gem which colorls))/tab_complete.sh
 
alias ls='colorls -A --sd'
alias lc='colorls -lA --sd'
 
##############
# Pygmentize #
##############
if ! command -v pygmentize &> /dev/null; then
    sudo pip install Pygments
fi

alias pcat='pygmentize -f terminal256 -O style=monokai -g'
 
###################################
# FZF                             #
# https://github.com/junegunn/fzf #
###################################
if ! command -v fzf &> /dev/null; then
    brew install fzf
fi

source $HOME/.fzf.zsh
 
function fd_dir_default_to_current {
 [[ -z $1 ]] && dir="." || dir=$1
 fdfind . $dir --type file --follow --hidden --exclude .git --color=always | fzf
}
export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --follow --exclude .git'
export FZF_COMPLETION_TRIGGER='**'
export FZF_DEFAULT_OPTS="--multi --ansi --height 50% --layout=reverse --border --info inline --preview 'bat --style=numbers --color=always --line-range :500 {}'"
 
alias fd='fdfind'
alias bat='batcat'
alias {z,z-file,zfile,zf}='fd_dir_default_to_current'
alias {z-history,zh}='history | fzf +s --tac --preview-window=hidden'
alias {z-cd,zcd}='cd $(fdfind --type directory | fzf)'
 
#########################
# Splitgate Development #
#########################

source "$HOME/.splitgate-service-vars"

########
# MISC #
########
if ! command -v terminal-notifier &> /dev/null; then
    brew install terminal-notifier
fi

function replace_w_symlink_mv {
    while [ $# -gt 1 ]; do
    eval "target=\${$#}"
    original="$1"
    if [ -d "$target" ]; then
        target="$target/${original##*/}"
    fi
    mv -- "$original" "$target"
    case "$original" in
        */*)
        case "$target" in
            /*) :;;
            *) target="$(cd -- "$(dirname -- "$target")" && pwd)/${target##*/}"
        esac
    esac
    ln -s -- "$target" "$original"
    shift
    done
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
