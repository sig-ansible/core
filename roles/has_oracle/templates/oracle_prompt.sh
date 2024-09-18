# Define a prompt which displays ORACLE_SID when it's set. This only affects
# supported shells.

SHELL_NAME=$(echo $SHELL |grep -oh '[a-z][a-z0-9_]*$')

case $SHELL_NAME in
    bash)
        export PS1='\[\e[37m\][\[\e[m\]\[\e[32m\]\u\[\e[m\]@\[\e[36m\]\h\[\e[m\] \W]\[\e[35m\]$([ -z "$ORACLE_SID" ]||echo \ $ORACLE_SID)\[\e[m\] \\$ '
        ;;
    ksh)
        PS1='$(print -n "`whoami`@`hostname`:";if [[ "${PWD#$HOME}" != "$PWD" ]] then; print -n "~${PWD#$HOME}"; else; print -n "$PWD";fi;print " $([ -z "$ORACLE_SID" ]||echo \ - $ORACLE_SID) $ ")'
        export PS1
        ;;
esac
