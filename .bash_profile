export PS1="\[\033[90m\]\u@\h\[\033[0m\] \[\033[01m\]\W\[\033[0m\]\[\033[32m\]\$(get_git_branch)\[\033[0m\] $ "
export LANG="cs_CZ.UTF-8"
export LC_COLLATE="cs_CZ.UTF-8"
export LC_CTYPE="cs_CZ.UTF-8"
export LC_MESSAGES="cs_CZ.UTF-8"
export LC_MONETARY="cs_CZ.UTF-8"
export LC_NUMERIC="cs_CZ.UTF-8"
export LC_TIME="cs_CZ.UTF-8"
export LC_ALL=

alias lh='ls -lhaG' # Complete file list with human readable filesize
alias reload='source ~/.bash_profile' # Reload .bash_profile
alias update='wget https://raw.githubusercontent.com/pavelsterba/dotfiles/master/.bash_profile -O ~/.bash_profile; reload' # Update .bash_profile from git
alias push='git branch --set-upstream-to=origin/`get_git_branch_raw` `get_git_branch_raw`; git pull; git push origin `get_git_branch_raw`' # Push current branch to origin
alias master='git checkout master; git pull' # Checkout to master and pull
alias test-checkout='git checkout test; git pull' # Checkout to test and pull
alias discard='git stash save -u; git stash drop "stash@{0}"' # Discard all changes in current branch
alias s='git diff -U0; git status' # Display status and changed lines in current branch
alias reload-dns='sudo killall -HUP mDNSResponder; sudo dscacheutil -flushcache' # Clear DNS cache
alias ports='netstat -tulnap tcp' # Processes on ports
alias venv='. venv/bin/activate' # Activate virtualenv


# Git auto completion - https://github.com/bobthecow/git-flow-completion
if [ -f ~/Documents/git-flow-completion.bash ]; then
    source ~/Documents/git-flow-completion.bash
fi
if [ -f /usr/local/bin/brew ]; then
    if [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
    fi
fi


# Aliases and scripts for work
if [ -f ~/.bash_profile_work ]; then
    source ~/.bash_profile_work
fi

# Aliases and scripts for Docker
if [ -f ~/.bash_profile_docker ]; then
    source ~/.bash_profile_docker
fi

# Aliases and scripts for nginx
if [ -f ~/.bash_profile_nginx ]; then
    source ~/.bash_profile_nginx
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

# Merge current branch to master
merge-to-master() {
    PSDFCURRENTBRANCH=`get_git_branch_raw`
    git branch --set-upstream-to=origin/$PSDFCURRENTBRANCH $PSDFCURRENTBRANCH
    git pull
    git rebase -i origin/master
    git checkout master
    git pull
    git merge --no-ff $PSDFCURRENTBRANCH
}

# Merge current branch to test
merge-to-test() {
    PSDFCURRENTBRANCH=`get_git_branch_raw`
    git branch --set-upstream-to=origin/$PSDFCURRENTBRANCH $PSDFCURRENTBRANCH
    git pull
    git checkout test
    git pull
    git merge $PSDFCURRENTBRANCH
}

# Delete current branch
delete-branch() {
    PSDFCURRENTBRANCH=`get_git_branch_raw`
    git checkout master
    git branch -D $PSDFCURRENTBRANCH
}
