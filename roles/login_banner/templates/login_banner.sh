#!/bin/bash

BANNER_STRING="{{ common_login_banner_text }}"

# Font Examples: http://www.figlet.org/examples.html
# NOTE: Not all fonts are available by default
#
# To get a sample of each font on the system:
#
# for F in /usr/share/figlet/*.flf; do echo $(basename $F .flf); figlet -f $(basename $F .flf) "SITE"; done |less
FIGLET_FONT="{{ common_login_banner_figlet_font }}"

INFO_LINE_WIDTH=8

thousands () {
    sed -re ' :restart ; s/([0-9])([0-9]{3})($|[^0-9])/\1,\2\3/ ; t restart '
}

max_line_width () {
    awk '{ print length }' | sort -n | tail -1
}

term_width () {
    expr $(tput cols) - 3
}

banner () {
    if [ -f /etc/banner ]; then
        # If there's a static banner, use that.
        cat /etc/banner
    elif which figlet >/dev/null 2>/dev/null; then
        # Figlet is our preferred banner generator
        figlet -f $FIGLET_FONT "$BANNER_STRING"
    elif which banner >/dev/null 2>/dev/null; then
        # Fall back to the old-school banner command
        banner "$BANNER_STRING"
    else
        # No banner printer found, just output the string
        echo "$BANNER_STRING"
    fi
}

info_line () {
    printf "%${INFO_LINE_WIDTH}s: %s" "$1"
}

os_info () {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        if [ -n "$PRETTY_NAME" ]; then
            echo "$PRETTY_NAME"
        else
            echo "$NAME $VERSION"
        fi
    else
        uname -srmo
    fi
}

info_block () {
    echo
    info_line "Hostname"; hostname
    info_line "IP"; ip a | grep glo | awk '{print $2}' | head -1 | cut -f1 -d/
    info_line "OS"; echo "$(os_info)"
    info_line "Memory"; echo "$(cat /proc/meminfo | grep MemFree | awk {'print $2'} | thousands)/$(cat /proc/meminfo | grep MemTotal | awk {'print $2'} | thousands) kB"
    info_line "Load"; cat /proc/loadavg |cut -d ' ' -f 1-3
}

two_col () {
    paste <(banner) <(info_block)
}

colorize () {
    if which lolcat >/dev/null 2>/dev/null; then
        lolcat -f
    else
        cat
    fi
}

show_banner () {
    if [ "$(two_col | max_line_width)" -gt "$(term_width)" ]; then
        banner | colorize
        info_block
    else
        paste <(banner | colorize) <(info_block)
    fi
}

show_banner
