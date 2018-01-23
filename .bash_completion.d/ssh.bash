# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
# -s True if file exists and has a size greater than zero.
[[ -e "${HOME}/.ssh/config" ]] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n' | grep -v "^$")" scp sftp ssh
