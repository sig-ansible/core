#!/bin/bash

go () {
    for F in {{about_root}}/*.txt; do
        cat $F
        echo
    done
}

go | less -eFX
