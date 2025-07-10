# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal dotfiles repository that configures development environments for macOS and Linux systems. The repository uses Fish shell as the primary shell and includes configurations for Neovim, VSCode, tmux, and custom scripts.

## Setup and Installation

- **Initial setup**: Run `./setup.fish` from the repository root to install and link all configurations
- **Fish shell setup**: The setup script installs Fisher package manager and Fish plugins from `fish/fishfile`
- **Manual linking**: Individual configurations can be linked using the `create_link` function defined in `setup.fish`

## Architecture

### Configuration Structure

- `fish/`: Fish shell configuration with modular core scripts loaded in order (00-colors, 01-variables, 02-aliases, 04-events, 04-keybindings)
- `nvim/`: Neovim configuration with separate plugin, settings, and keymap files
- `vscode/`: VSCode settings and keybindings
- `core/`: Core configuration files (GPG, etc.) that get linked to home directory
- `bin/`: Custom TypeScript/Node.js scripts with CLI interface
- `tmux/`: tmux configuration files

### Key Design Patterns

- Fish configuration uses numbered prefixes (00-, 01-, 02-) to control load order
- All Fish core scripts are automatically sourced via `fish/config.fish`
- Custom aliases tracked in `__DOTFILES_ALIASES` global variable for easy listing
- Scripts in `bin/` provide Fish completions automatically
- Environment variables and PATH modifications are platform-specific (Darwin vs Linux)

### Development Scripts

The `bin/` directory contains TypeScript-based CLI tools:

- **Build/Lint**: `npm run lint` (ESLint with TypeScript support)
- **Dependencies**: Uses pnpm for package management
- **Completion**: Scripts provide Fish shell completions via `--completion-fish` flag

### Fish Functions

Custom Fish functions in `fish/functions/` provide utilities like:

- `do`: Project task runner with FZF integration
- `g`/`gr`: Git shortcuts with branch search
- `l`: Enhanced ls with exa/eza
- `lc`: Directory navigation with history
- `tmpd`: Temporary directory creation

### Environment Configuration

- **Editor**: Neovim (`$EDITOR`)
- **Python**: pyenv integration for version management
- **Tmux**: Auto-starts main session for interactive shells
- **GPG/SSH**: Keychain integration on Linux, native on macOS
- **Theme**: bobthefish with Nerd Fonts support

## Platform Differences

- **macOS**: Uses Homebrew paths, includes Android SDK, Java paths
- **Linux**: Includes systemd/WSL integration, different package managers (yay for Arch)
- **Path priorities**: Homebrew bins, dotfiles bin, local node_modules/.bin take precedence
