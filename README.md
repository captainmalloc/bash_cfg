# bash_cfg
Custom configuration for Bash

# zshrc on MacOS

Setup Zsh in MacOS:

If the installed one is find:

```sh
chsh -s /bin/zsh
```

If you'd like to install a more recent version:

```sh
dscl . -read /Users/$USER UserShell
```

Install latest version of Zsh:

```sh
sudo dscl . -create /Users/$USER UserShell /usr/local/bin/zsh
```

Install OhMyZsh:

```sh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```

Links:

https://rick.cogley.info/post/use-homebrew-zsh-instead-of-the-osx-default/

https://ohmyz.sh

https://github.com/robbyrussell/oh-my-zsh