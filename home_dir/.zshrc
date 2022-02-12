#################################################################################################
# Awesome Tips For Terminal!                                                                    #
# https://medium.com/@ivanaugustobd/your-terminal-can-be-much-much-more-productive-5256424658e8 #
#################################################################################################
 
########
# MAIN #
########

# Update all outdated brew apps
brew cu --all -q

export PATH=$HOME/bin:/usr/local/bin:$HOME/thatguyrussell/.local/bin:/opt/homebrew/lib/ruby/gems/3.1.0/bin:$PATH
export JAVA_HOME=$(/usr/libexec/java_home -v 17)
export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"
 
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

##############
# Core Tools #
##############

# Brew
if ! command -v brew &> /dev/null; then
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh
fi

# Pip
if [[ $OSTYPE == 'linux'* ]]; then
        sudo apt-get install python3-pip
fi

if ! command -v pip &> /dev/null; then
    python -m ensurepip --upgrade --user
fi

# Ruby
if ! command -v ruby &> /dev/null; then
    if [[ $OSTYPE == 'darwin'* ]]; then
        brew install ruby
    fi

    if [[ $OSTYPE == 'linux'* ]]; then
        sudo apt-get install ruby
    fi
fi  

# Gradle
if ! command -v gradle &> /dev/null; then
    if [[ $OSTYPE == 'darwin'* ]]; then
        brew install gradle
    fi

    if [[ $OSTYPE == 'linux'* ]]; then
        sudo apt-get install gradle
    fi
fi

# Git
alias edit_git_config="code $HOME/.gitconfig"
alias edit_work_git_config="code $HOME/.gitconfig-work"

if ! command -v diff-so-fancy &> /dev/null; then
    if [[ $OSTYPE == 'darwin'* ]]; then
        brew install diff-so-fancy
    fi

    if [[ $OSTYPE == 'linux'* ]]; then
        sudo apt-get install diff-so-fancy
    fi
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
    pip install colorls --user
fi

source $(dirname $(gem which colorls))/tab_complete.sh
 
alias ls='colorls -A --sd'
alias lc='colorls -lA --sd'
 
##############
# Pygmentize #
##############
if ! command -v pygmentize &> /dev/null; then
    brew install pygments
fi

alias pcat='pygmentize -f terminal256 -O style=monokai -g'
 
###################################
# FZF                             #
# https://github.com/junegunn/fzf #
###################################
if ! command -v fzf &> /dev/null; then
    if [[ $OSTYPE == 'darwin'* ]]; then
        brew install fzf
    fi

    if [[ $OSTYPE == 'msys'* ]]; then
        
    fi
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

# None Yet

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
