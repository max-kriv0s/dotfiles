# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Packages

| Package  | Description        |
|----------|--------------------|
| ghostty  | Terminal emulator  |

## Requirements

- macOS or Linux
- [Homebrew](https://brew.sh) (macOS)

## Install

git clone https://github.com/<you>/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh

## Adding a new package

1. Create a folder: `mkdir -p ~/dotfiles/<name>/<path mirroring $HOME>`
2. Move config: `mv ~/.config/<name> ~/dotfiles/<name>/.config/<name>`
3. Stow it: `stow <name>`
4. Add to `PACKAGES` array in `install.sh`
5. Update this README
