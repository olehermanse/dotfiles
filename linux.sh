source /local/lib/setupfiles/bashrc
export PATH="$PATH:/snacks/bin/"
LS_COLORS="$LS_COLORS:di=00;33"

alias emacs='emacs-newest'
alias age='~baldersh/pub/aoe2 shm'
alias cadence='cd ~/programs/Cadence2/ && source CRN90LP_session_IC616 && virtuoso& \r'
alias ff='firefox&'
alias logisim='java -jar ~/programs/logisim-generic-2.7.1.jar&'
alias g='gedit&'

alias fixweb='chmod -R a+rX ~/www_docs'
alias publish='python3 ~/edu/website/compile.py && rm -rf ~/www_docs && cp -R ~/edu/website ~/www_docs && chmod -R a+rX ~/www_docs && chmod -R a+rX ~/www_docs'

function cleaner {
    find . -type d -regex ".*__MACOSX" -exec rm -rvf {} +
    find . -type d -regex "\.\/.*adexl\/results" -exec rm -rvf {} +
    find . -type d -regex "\.\/.*adexl\/test_states\/.*Interactive.*" -exec rm -rvf {} +
    find . -type f -regex "\.\/.*\(~\|~.*\|cdslck\|CDS\.log\|\.DS_Store\|\._.*\)" -exec rm -v {} +
}
alias clean="cleaner | wc -l"
