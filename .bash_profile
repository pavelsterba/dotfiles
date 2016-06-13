export PS1="\033[90m\u@\h\033[0m \033[01m\W\033[0m\033[32m\$(get_git_branch)\033[0m $ "


alias lh='ls -lha' # Complete file list with human readable filesize
alias reload='source ~/.bash_profile' # Reload .bash_profile
alias update='wget https://raw.githubusercontent.com/pavelsterba/dotfiles/master/.bash_profile -O ~/.bash_profile; reload' # Update .bash_profile from git
alias push='git branch --set-upstream-to=origin/`get_git_branch_raw` `get_git_branch_raw`; git pull; git push origin `get_git_branch_raw`' # Push current branch to origin
alias master='git checkout master; git pull' # Checkout to master and pull
alias test-checkout='git checkout test; git pull' # Checkout to test and pull
alias discard='git checkout .; git stash save -u; git stash drop "stash@{0}"' # Discard all changes in current branch
alias s='git diff -U0; git status' # Display status and changed lines in current branch
alias reload-dns='sudo killall -HUP mDNSResponder; sudo dscacheutil -flushcache' # Clear DNS cache
alias ports='netstat -tulnap tcp' # Processes on ports


# Git auto completion - https://github.com/bobthecow/git-flow-completion
if [ -f ~/Documents/git-flow-completion.bash ]; then
    source ~/Documents/git-flow-completion.bash
fi
if [ -f /usr/local/bin/brew ]; then
    if [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
    fi
fi


# Get current git branch
get_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ [\1]/'
}

# Get current git branch in raw format (only name without brackets)
get_git_branch_raw() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

# Commit staged changes with message
commit-staged() {
    git diff -U0
    git commit -m "$1"
}

# Stage all files and commit them with message
commit() {
    git diff -U0
    git add .
    git commit -m "$1"
}

# Create new branch from latest master
create-branch() {
    git checkout master
    git pull
    git checkout -b $1
}

# Create directory and enter it
mkdcd() {
    mkdir $1 && cd $1
}
