if status is-interactive
	# Commands to run in interactive sessions can go here
	set -g fish_greeting ""
	alias ls='lsd'
	alias cat='bat'
	alias df='dfc'
	alias lsblk='lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT'
	zoxide init fish | source
end

# Created by `pipx` on 2025-12-09 13:52:56
set PATH $PATH /home/dm/.local/bin

set -g theme_show_time yes
