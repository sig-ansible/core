#
# THIS FILE IS MAINTAINED BY ANSIBLE - DO NOT EDIT MANUALLY
#

# Display banner if STDOUT is a terminal and the command exists
[ -t 1 ] && [ -x "{{ common_login_banner_command_path }}" ] && {{ common_login_banner_command_path }}
