# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Structure
dotfiles/
├── ghostty/                    # Terminal emulator config
├── docs/
│   └── tools.md                # Terminal tools cheatsheet
├── packages/
│   ├── macos/
│   │   ├── Brewfile            # Homebrew packages
│   │   └── manual.md           # Apps installed manually
│   └── fedora/
│       ├── packages.sh         # DNF packages
│       ├── flatpak.sh          # Flatpak packages
│       └── manual.md           # Apps installed manually
├── scripts/
│   └── macos-defaults.sh       # macOS system defaults
├── local/
│   ├── .gitconfig.local.example
│   └── .zshrc.local.example
├── .stowrc
└── install.sh

## Stow Packages

| Package | Description |
|---------|-------------|
| ghostty | Terminal emulator |

## Requirements

- macOS or Linux (Fedora)
- [Homebrew](https://brew.sh) (macOS only)
- [GNU Stow](https://www.gnu.org/software/stow/)

## Install

```bash
git clone https://github.com/max-kriv0s/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh
```

## Manual Installation

Some apps are not available via package managers.
See platform-specific instructions:
- [macOS](packages/macos/manual.md)
- [Fedora](packages/fedora/manual.md)

## Adding a new package

1. Create folder: `mkdir -p ~/dotfiles/<name>/<path mirroring $HOME>`
2. Move config: `mv ~/.config/<name> ~/dotfiles/<name>/.config/<name>`
3. Stow it: `cd ~/dotfiles && stow <name>`
4. Add to `PACKAGES` array in `install.sh`
5. Update this README

## Local configuration

Machine-specific settings are stored in `*.local` files — not committed to git.
On first run `install.sh` creates them from examples:

- `~/.gitconfig.local` — git username, email, GPG key
- `~/.zshrc.local` — machine-specific env vars, paths

## Docs

- [Terminal tools cheatsheet](docs/tools.md)
