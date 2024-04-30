# My Dotfiles 🚀
This repository just contains the dotfiles for my entire macos system.

It uses GNU Stow to setup the dotfiles symlinks

## Requirements

Ensure that you have the following installed in your system

### Git
```
brew install git
```

### Stow
```
brew install stow
```

## Installation

Firstly, ensure that you checkout the dotfiles repo to your local $HOME directory using git

```
$ git clone git@github.com:kyapwc/dotfiles.git
$ cd dotfiles
```

then just run the prepared shell script using
```
$ ./setup_symlinks.sh
```
