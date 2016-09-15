alias hw='echo "Hello World, olehermanse bashrc files are active."'

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

# VM
alias vm_client='sudo rpm -i dl/cfengine-nova-3.7.4-1.x86_64.rpm && rm -fv dl/*'
alias vm_bootstrap='sudo /var/cfengine/bin/cf-agent --bootstrap	192.168.56.98'
alias vm_ip='sudo nano /etc/sysconfig/network-scripts/ifcfg-enp0s8'

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
alias bashreload='source ~/edu/bashrc'
alias bashrc='open ~/edu/bashrc'

alias vmshut="vboxmanage list runningvms | gsed -r 's/.*\{(.*)\}/\1/' | xargs -L1 -I {} VBoxManage controlvm {} acpipowerbutton"
alias vms="vboxmanage list runningvms"

alias rmssh="sudo rm -fv /etc/ssh/ssh_host*"
alias dev="ssh 192.168.56.99"
alias hub="ssh 192.168.56.98"

set completion-ignore-case on
set show-all-if-ambiguous on

alias pdflatex='pdflatex -shell-escape'

alias devilry_sort='python ~/edu/github/Devilry_sort/sort_deliveries.py'
alias sync='~/edu/tools/bsync -o "-S ~/tempedu" ~/edu olehelg@login.ifi.uio.no:edu'
