#!/usr/bin/env bash

function bashuninstall {
    sed -i.bu "/.dotfiles_olehermanse/d" $HOME/.bashrc && rm -f $HOME/.bashrc.bu
    sed -i.bu "/.dotfiles_olehermanse/d" $HOME/.bash_profile && rm -f $HOME/.bashrc.bu

    if [ -d ~/.dotfiles_olehermanse ]; then
       rm -rf ~/.dotfiles_olehermanse
    fi
}

function mylatex {
    filename=$(basename "$1")
    filename="${filename%.*}"
    mkdir -p ./.latex
    if [ -d "./.latex/_minted-"$filename ]; then
       mv "./.latex/_minted-"$filename ./
    fi
    pdflatex -shell-escape -output-directory "./.latex" "${1/.pdf/.tex}"
    mv ./.latex/*.pdf ./
    mv _minted-$filename ./.latex
}

function triplelatex {
    filename=$(basename "$1")
    filename="${filename%.*}"
    mkdir -p ./.latex
    if [ -d "./.latex/_minted-"$filename ]; then
       mv "./.latex/_minted-"$filename ./
    fi
    pdflatex -shell-escape -output-directory "./.latex" "${1/.pdf/.tex}"
    biber "${1/.tex/}" --input-directory .latex --output-directory .latex
    pdflatex -shell-escape -output-directory "./.latex" "${1/.pdf/.tex}"
    pdflatex -shell-escape -output-directory "./.latex" "${1/.pdf/.tex}"
    mv ./.latex/*.pdf ./
    mv _minted-$filename ./.latex
}

# Initialize git config:
function initgit {
    git config --global push.default current
    git config --global alias.css "commit -S -s"
    git config --global alias.cssan "commit -S -s --author 'Anonymous <>'"
    echo "You should run these manually:"
    echo "git config --global user.name  'Your Name'"
    echo "git config --global user.email 'your@email'"
    echo "git config --global user.signingkey yourkeyid"
}

# tar:
function entar {
    target=${1%/}
    tar -cf "$target.tar" "$target"
}

function entgz {
    target=${1%/}
    tar -czf "$target.tgz" "$target"
}

function untar {
    tar -xzf "$1"
}

alias untgz='untar'

# Create feedback folder and open feedback file:
function feedback {
    mkdir -p "../feedback"
    if [ ! -e "../feedback/template.md" ]; then
       cp ~/edu/teach/template.md ../feedback/template.md
    fi
    open "../feedback/template.md"
    mkdir -p "../feedback/$1"
    if [ ! -e "../feedback/$1/1.md" ]; then
       cp "../feedback/template.md" "../feedback/$1/1.md"
    fi
    open "../feedback/$1/1.md"
    cd $1
    open *.pdf
    cd ..
}

function swap-files {
    mv $1 /tmp/swap-files-temp.txt1
    mv $2 $1
    mv /tmp/swap-files-temp.txt1 $2
    rm -f /tmp/swap-files-temp.txt1
}

function cherry {
    git cherry-pick -x $1
}

alias fb='feedback'
function feedback2 {
    mkdir -p "../feedback"
    if [ ! -e "../feedback/template.md" ]; then
       cp ~/edu/teach/template.md ../feedback/template.md
    fi
    open "../feedback/template.md"
    mkdir -p "../feedback/$1"
    if [ ! -e "../feedback/$1/2.md" ]; then
       cp "../feedback/template.md" "../feedback/$1/2.md"
    fi
    open "../feedback/$1/2.md"
    cd $1
    open *.pdf
    cd ..
}
alias fb2='feedback2'

function titc {
    tit $@ | pbcopy
}

function aa {
    echo 'alias' $1 >> ~/edu/bashrc
    source ~/edu/bashrc
}

function git-delete-safe {
    if [ $# != 1 ]; then
        echo "Specify branch name!"
        return 1
    fi
    git branch -d $1 && git push origin --delete $1
    if [ $? != 0 ]; then
        echo "An error has occured, most likely branch is not fully merged or remote doesn't exist"
        return 1
    fi
}

function git-delete {
    if [ $# != 1 ]; then
        echo "Specify branch name!"
        return 1
    fi
    git push origin --delete $1
    if [ $? != 0 ]; then
        echo "Important! Could not delete remote branch"
        echo "           It most likely doesn't exist"
    fi
    git remote prune origin
    git branch -d $1
    if [ $? != 0 ]; then
        echo "Important! Could not delete local branch"
        return 1
    fi
}

alias git-branch-delete="git-delete"

function git-delete-force {
    if [ $# != 1 ]; then
        echo "Specify branch name!"
        return 1
    fi
    git push origin --delete $1;
    git branch -D $1;
}

alias git-branch-delete-force="git-delete-force"

function gc {
    if [ $# != 2 ]; then
        echo "Specify user / org and repo"
        return 1
    fi
    git clone --recursive git@github.com:$1/$2.git
}

function gai {
    last_message=$(git log -1 --pretty=%B)
    new_message="${last_message}
    Co-authored-by: Claude <noreply@anthropic.com>"
    git commit --amend -m "$new_message"
    git log -n 1
}
