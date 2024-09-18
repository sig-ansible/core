#!/bin/bash

sids_from_tnsnames () {
    grep -oh '^[A-Z][A-Z0-9]*' $1
}

find_sids () {
    # List SIDs from oratab
    [ -f /etc/oratab ] && grep '^[A-Z][^:]*:' /etc/oratab |cut -f 1 -d ':'

    # It was decided to restrict alias creation to those in defined in oratab
    # since otherwise you'd be prompted for ORACLE_HOME anyway.
    # To add an alias, simply create an entry in oratab to map it's ORACLE_HOME.

    # If ORACLE_HOME is set and has a tnsnames.ora file, then
    # we'll just use that one. Otherwise, try to use locate.
    # if [ -f "$ORACLE_HOME/network/admin/tnsnames.ora" ]; then
    #   sids_from_tnsnames "$ORACLE_HOME/network/admin/tnsnames.ora"
    # else
    #   for f in $(locate tnsnames.ora |grep -v sample); do
    #       sids_from_tnsnames $f
    #   done
    # fi
}

all_sids () {
    find_sids | sort -u
}

# For each unique SID, create an oraenv alias
for sid in $(all_sids); do
    alias $sid="export ORACLE_SID=$sid; export ORAENV_ASK=NO; source oraenv -s; unset ORAENV_ASK"
done
