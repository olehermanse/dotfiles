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
    pdflatex -shell-escape -output-directory "./.latex" "${1/.pdf/.tex}"
    pdflatex -shell-escape -output-directory "./.latex" "${1/.pdf/.tex}"
    mv ./.latex/*.pdf ./
    mv _minted-$filename ./.latex
}

function vmstop {
    vboxmanage controlvm "$1" acpipowerbutton
}

function vmstart {
    vboxmanage startvm "$1" --type headless
}

function vmclone {
    vboxmanage clonevm "VMX Clean" --name "$1" --register
    vboxmanage startvm "$1" --type headless
    ssh-keygen -R 192.168.56.199
}

function vmremove {
    VBoxManage unregistervm "$1" --delete
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
