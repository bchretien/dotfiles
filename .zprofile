# Load .Xresources (if any)
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# run local .zprofile
source ~/.zprofile.local

gpg-agent --daemon

eval $(keychain --eval --agents ssh -Q --quiet id_ecdsa)
