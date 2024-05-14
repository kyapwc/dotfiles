# My Dotfiles 🚀
This repository just contains the dotfiles for my entire macos system.

It uses GNU Stow to setup the dotfiles symlinks and various shell scripts.

## Details
- Terminal: [WezTerm](https://wezfurlong.org/wezterm/index.html) + zsh
- WM: [yabai]((https://github.com/koekeishiya/yabai)) + [skhd](https://github.com/koekeishiya/skhd)
- Bar: [Sketchybar](https://github.com/FelixKratz/SketchyBar)
- Browser: [Arc](https://arc.net/)
- Borders: [JankyBorders](https://github.com/FelixKratz/JankyBorders)
- Main Editor: [Neovim](https://neovim.io/)

## Disclaimer

> [!CAUTION]
> Don't run it before reading ! It's going to erase most of your homebrew packages !

> [!WARNING]
> The repository should be cloned in the `$HOME` directory, as scripts expects the root to be located in `$HOME/dotfiles`.

## Pre-requisite
Generally, as a developer starting on a new MacOS system `git` is definitely required and for that `xcode-select` **MUST** be installed. Therefore, I usually spawn a terminal and run:
```sh
$ xcode-select --install
```

After that, just simple commands:
```
git clone https://github.com/kyapwc/dotfiles
cd dotfiles
./install.sh
```

## How everything works?
[install.sh](./install.sh) bootstraps a few scripts that are available in the `scripts` folder:
- [prelude.sh](./scripts/prelude.sh) Installs homebrew
- [system.sh](./scripts/system.sh) Set up MacBook preferences
- [brewer.sh](./scripts/brewer.sh) Install all packages that are required in base system with Homebrew Bundle that are specified in [packages.brew](./packages.brew). Please note that it actually syncs the system packages with the file, removing packages that are already installed in your system if necessary!
- [dotfiles.sh](./scripts/dotfiles.sh) Performs linking of my config files (e.g: `.zshrc`, `.config/nvim`, `.config/wezterm`, etc..)
- [aftermath.sh](./scripts/aftermath.sh) Performs some post-install setup of things, such as yabai, skhd, asdf-vm node install, janky_borders, etc..
- [setup_symlinks.sh](./scripts/setup_symlinks.sh) Using GNU stow to symlink all directories

## Inspiration
Inspiration was taken from this repo: [Carbone13's Dotfiles](https://github.com/Carbone13/dotfiles) for the install.sh.

Was previously fully using GNU Stow only but found it lacking
