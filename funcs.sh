#!/usr/bin/env bash

function bashuninstall {
    source_line='source ~/.dotfiles_olehermanse/start.sh'
    sed -i.bu "/$source_line/d" $HOME/.bashrc && rm -f $HOME/.bashrc.bu
    sed -i.bu "/$source_line/d" $HOME/.bash_profile && rm -f $HOME/.bashrc.bu

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

function aa {
    echo 'alias' $1 >> ~/edu/bashrc
    source ~/edu/bashrc
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
        echo "           To delete local branch use: 'git branch -d $1'"
        return 1
    fi
    git branch -d $1
    if [ $? != 0 ]; then
        echo "Important! Branch not fully merged"
        echo "           It was most likely deleted remote but not locally"
        echo "           You should 'git checkout $1' and 'git push'"
        echo "           If you know what you're doing, you can use 'git-delete-force $1'"
        return 1
    fi
}

function git-delete-force {
    if [ $# != 1 ]; then
        echo "Specify branch name!"
        return 1
    fi
    git push origin --delete $1;
    git branch -D $1;
}
