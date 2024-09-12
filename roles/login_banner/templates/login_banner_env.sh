#
# THIS FILE IS MAINTAINED BY ANSIBLE - DO NOT EDIT MANUALLY
#

# Display banner if STDOUT is a terminal and the command exists
[ -t 1 ] && [ -x "{{ login_banner_command_path }}" ] && {{ login_banner_command_path }}
