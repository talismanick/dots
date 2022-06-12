# .bash_profile

# Get the aliases and functions
[ -f "${HOME}/.bashrc" ] && . "${HOME}/.bashrc"
source /etc/profile

export PATH="$PATH:${HOME}/.local/script:${HOME}/.local/bin"
# broken on first startup: -a \"emacs\"
export VISUAL="nt-emacs"
export EDITOR="$VISUAL"
export SUDO_EDITOR="$EDITOR"

# Void & xbps-src paths
export XBPS_DISTDIR="${HOME}/.local/void/void-packages"
export SVDIR="${HOME}/.local/service/"

# XDG defaults
export XDG_RUNTIME_DIR="${HOME}/.local/run"
export XDG_CONFIG_HOME="${HOME}/.config"

# Window management
export XKB_DEFAULT_OPTIONS=ctrl:nocaps

# Fonts, locales, etc
#export LC_ALL="C"

# mail
export NOTMUCH_CONFIG="${XDG_CONFIG_HOME}/notmuch/notmuch.conf"

# Python
export PATH="$PATH:${HOME}/.poetry/bin"
export PYENV_ROOT="${HOME}/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PIP_REQUIRE_VIRTUALENV=1
export USE_EMOJI=0 # for pipx
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"

# Haskell
export PATH="$PATH:${HOME}/.cabal/bin/:${HOME}/.ghcup/bin"
export GHCUP_USE_XDG_DIRS="true"

# Rust
#export PATH="$PATH:${HOME}/.cargo/bin"

. "$HOME/.cargo/env"
