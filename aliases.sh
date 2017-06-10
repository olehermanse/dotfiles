alias hw='echo "Hello World, olehermanse bashrc files are active. 1.1"'
alias sudo='sudo '

# Change dir shortcuts:
alias root='cd /'
alias ~='cd ~'
alias ..='cd ..'
alias subdirs='ls -Ap | grep "/" && echo "Total:" && ls -Ap | grep "/" | wc -l'
alias emacs='emacs --no-window'

# History and time:
alias fuck='sudo $(history -p \!\!)'
alias back='cd - #'
alias now='date'
alias ls='ls'
alias fire='X="emergency_branch_fire_`whoami`_`date +%s`" ; git checkout -b $X ; git add -A ; git commit -m "FIRE! FIRE! Looking forward to hearing from you." ; git push'

# Network:
alias ssh6Y='ssh -YC olehelg@rh6login.ifi.uio.no'
alias ssh7Y='ssh -YC olehelg@rh7login.ifi.uio.no'
alias ssh6='ssh olehelg@rh6login.ifi.uio.no'
alias ssh7='ssh olehelg@rh7login.ifi.uio.no'
alias uio='ssh -YC olehelg@vetur.ifi.uio.no'
alias fui='ssh -YC fui@login.ifi.uio.no'
alias server='python -m SimpleHTTPServer'

alias start-work="echo Started working: `date` >> ~/work.log"
alias stop-work="echo Stopped working: `date` >> ~/work.log"
alias work="emacs ~/work.log"

# Files:
alias path='echo -e ${PATH//:/\\n}'
alias del='rm -rvf'
alias pdf='open *.pdf'
alias py='open *.py'
alias bashreload='source $HOME"/.bash_profile"'
alias bashrc='atom ~/.setup-bash'
if [ -d $HOME"/code/setup-bash" ]; then
    alias bashrc='atom '$HOME'/code/setup-bash'
fi
alias bashreinstall='bash <(curl -L -s bit.ly/instsb) && source $HOME/.bash_profile'

alias vmshut="vboxmanage list runningvms | gsed -r 's/.*\{(.*)\}/\1/' | xargs -L1 -I {} VBoxManage controlvm {} acpipowerbutton"
alias vms="vboxmanage list runningvms"


alias pdflatex='pdflatex -shell-escape'

alias devilry_sort='python ~/code/Devilry_sort/sort_deliveries.py'
alias sync='~/edu/tools/bsync/bsync -i -y -o "-S ~/tempedu" ~/edu olehelg@login.ifi.uio.no:edu'

alias poop='export PS1="💩  "'
alias prompt-micro='export PS1="$ "'
alias prompt-mini='export PS1="\\W $ "'
alias prompt-standard='export PS1="\\h:\\w $ "'
alias prompt-full='export PS1="\\h:\\w $ "'

alias prompt-time-micro='export PS1="\\t $ "'
alias prompt-time-mini='export PS1="\\t \\W $ "'
alias prompt-time-standard='export PS1="\\t \\h:\\w $ "'
alias prompt-time-full='export PS1="\\t \\h:\\w $ "'
