source $HOME/.dotfiles/utils.sh

# Default battery (used by i3blocks)
export BATTERY_ID=BAT1

# Load .Xresources (if any)
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# run local .zprofile
source ~/.zprofile.local

run_process gpg-agent --daemon &>/dev/null

# load keychain to manage SSH and GPG keys
if command -v keychain &>/dev/null; then
  keychain --eval --agents ssh -Q --quiet id_rsa &>/dev/null
fi
