# https://github.com/mbadolato/iTerm2-Color-Schemes
if [ -d $HOME/iTerm2-Color-Schemes ]; then
  cd $HOME/iTerm2-Color-Schemes
  git pull
else
  git clone https://github.com/mbadolato/iTerm2-Color-Schemes $HOME/iTerm2-Color-Schemes
fi
