# linux-dotfiles
linux dotfiles setup ( currently tested with ubuntu, near future fedora, coreOS )


# Thanks
- https://github.com/jessfraz/dotfiles
- https://github.com/jessfraz/dockerfiles
- https://github.com/blacktop/dotfiles
- https://dotfiles.github.io/
- https://github.com/bndabbs/dotfiles
- https://github.com/webpro/dotfiles



# LOOK AT THIS ONE

- https://github.com/webpro/dotfiles


# Test in docker container

```
docker build --force-rm --no-cache -t dotfiles .

docker run -it dotfiles:latest bash
```


# Install?

```

1  cd ~/.dotfiles/
2  git pull
3  clear
4  git pull
5  clear
6  source ~/.dotfiles/install.sh
7  source ~/.nvm/nvm.sh
8  nvm ls
9  npm search bats
10  histor
11  history

```


# wip ~/.bashrc

```
source ~malcolm/.pyenv/.pyenvrc
source ~malcolm/.pyenv/completions/pyenv.bash

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[ -f /Users/malcolm/.nvm/versions/node/v10.3.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.bash ] && . /Users/malcolm/.nvm/versions/node/v10.3.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.bash
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[ -f /Users/malcolm/.nvm/versions/node/v10.3.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.bash ] && . /Users/malcolm/.nvm/versions/node/v10.3.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.bash
```
