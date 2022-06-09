# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#alias emacs='vsv stop emacs; emacs'

alias sudo='doas'
alias sd='sudo'

alias ls='ls --color=auto -h'
alias ll='ls -la '

alias mkdir='mkdir -pv'
alias rm='srm'
alias grep='rg --color=auto'
alias untar='tar -zxvf'
alias sha='shasum -a 256'

alias wget='wget -c'
alias ipe='curl ipinfo.io/ip'
alias ipi='ipconfig getifaddr en0'

alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'

alias ports='netstat -tulanp'

alias xi='sudo xi'
alias xrr='sudo xbps-remove -R'
alias xr='sudo xbps-remove'
alias xd='xbps-query -x'

alias c='clear'
alias h='history'
alias j='jobs -l'

alias reboot='sudo reboot'
alias poweroff='sudo /sbin/poweroff'
alias halt='sudo /sbin/halt'
alias shutdown='sudo /sbin/shutdown'
alias zzz='doas env XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR}" zzz'

alias virsh='sudo virsh'

alias ufw='sudo ufw'
alias ipsec='sudo ipsec'

alias xkcdpass="xkcdpass | sed 's| |-|g' -"
alias river="run-river"

# rebind iff terminal allows line editing

[[ ${SHELLOPTS} =~ (vi|emacs) ]] && bind '\C-w:backward-kill-word'

### terminal (Emacs vterm) setup

vterm_printf() {
        if [ -n "$TMUX" ] && { [ "${TERM%%-*}" = "tmux" ] || [ "${TERM%%-*}" = "screen" ]; }; then
                # Tell tmux to pass the escape sequences through
                printf "\ePtmux;\e\e]%s\007\e\\" "$1"
        elif [ "${TERM%%-*}" = "screen" ]; then
                # GNU screen (screen, screen-256color, screen-256color-bce)
                printf "\eP\e]%s\007\e\\" "$1"
        else
                printf "\e]%s\e\\" "$1"
        fi
}

PROMPT_COMMAND='echo -ne "\033]0;${HOSTNAME}:${PWD}\007"'

vterm_prompt_end() {
        vterm_printf "51;A$(whoami)@$(hostname):$(pwd)"
}
vterm_set_directory() {
        vterm_cmd update-pwd "$PWD/"
}

if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
        PS1='[\u@\h \W]\$ \[$(vterm_prompt_end)\]'
        function clear() {
                vterm_printf "51;Evterm-clear-scrollback"
                tput clear
        }
else
        PS1='[\u@\h \W]\$ '
fi

vterm_cmd() {
        local vterm_elisp
        vterm_elisp=""
        while [ $# -gt 0 ]; do
                vterm_elisp="$vterm_elisp""$(printf '"%s" ' "$(printf "%s" "$1" | sed -e 's|\\|\\\\|g' -e 's|"|\\"|g')")"
                shift
        done
        vterm_printf "51;E$vterm_elisp"
}

# user-defined vterm commands
find_file() {
        vterm_cmd find-file "$(realpath "${@:-.}")"
}
say() {
        vterm_cmd message "%s" "$*"
}

# auxiliary utility function(s)
map() {
        local command
        if [ $# -lt 2 ] || [[ ! "$*" =~ :[[:space:]] ]]; then
                echo "Invalid syntax." >&2
                return 1
        fi
        until [[ $1 =~ : ]]; do
                command="$command $1"
                shift
        done
        command="$command ${1%:}"
        shift
        for i in "$@"; do
                eval "${command//\\/\\\\} \"${i//\\/\\\\}\""
        done
}
nsg() {
        netstat -natp | grep -i "${1}"
}

### global setup function calls
if [[ "$INSIDE_EMACS" = 'vterm' ]]; then # only annoying, post-boot ones in here
        # SSH
        eval "$(keychain --agents ssh --eval id_rsa)"

        # Python
        source "${HOME}/.pyenv/completions/pyenv.bash"
fi

eval "$(register-python-argcomplete pipx)"

# direnv
eval "$(direnv hook bash)"

#[ -f "${HOME}/.ghcup/env" ] && source "${HOME}/.ghcup/env" # ghcup-env
fortune

echo -e '\n'
