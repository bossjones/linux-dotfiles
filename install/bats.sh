if is-executable node -o ! is-executable curl -o ! is-executable git; then
  echo "Skipped: Homebrew (missing: node, curl and/or git)"
  return
fi

# linux-only
mkdir -p ~/dev/
cd ~/dev
git clone https://github.com/sstephenson/bats.git
cd bats
./install.sh /usr/local
