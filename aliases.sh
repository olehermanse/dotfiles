alias hw='echo "Hello World, olehermanse bashrc files are active. 1.1"'
alias sudo='sudo '

# Change dir shortcuts:
alias root='cd /'
alias ~='cd ~'
alias ..='cd ..'
alias subdirs='ls -Ap | grep "/" && echo "Total:" && ls -Ap | grep "/" | wc -l'

# History and time:
alias fuck='sudo $(history -p \!\!)'
alias back='cd - #'
alias now='date'
alias ls='ls'

# Network:
alias ssh6Y='ssh -YC olehelg@rh6login.ifi.uio.no'
alias ssh7Y='ssh -YC olehelg@rh7login.ifi.uio.no'
alias ssh6='ssh olehelg@rh6login.ifi.uio.no'
alias ssh7='ssh olehelg@rh7login.ifi.uio.no'
alias uio='ssh -YC olehelg@login.ifi.uio.no'
alias fui='ssh -YC fui@login.ifi.uio.no'
alias server='python -m SimpleHTTPServer'

# Files:
alias path='echo -e ${PATH//:/\\n}'
alias del='rm -rvf'
alias pdf='open *.pdf'
alias py='open *.py'
alias bashreload='source $HOME"/.bash_profile"'
alias bashrc='atom ~/.setup-bash'
if [ -d $HOME"/Dev/setup-bash" ]; then
    alias bashrc='atom '$HOME'/Dev/setup-bash'
fi
alias bashreinstall='bash <(curl -L -s bit.ly/instsb) && source $HOME"/.bash_profile"'

alias vmshut="vboxmanage list runningvms | gsed -r 's/.*\{(.*)\}/\1/' | xargs -L1 -I {} VBoxManage controlvm {} acpipowerbutton"
alias vms="vboxmanage list runningvms"


alias pdflatex='pdflatex -shell-escape'

alias devilry_sort='python ~/Dev/Devilry_sort/sort_deliveries.py'
alias sync='~/edu/tools/bsync -i -o "-S ~/tempedu" ~/edu olehelg@login.ifi.uio.no:edu'
