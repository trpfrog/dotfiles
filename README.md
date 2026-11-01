<h1 align="center">trpfrog/dotfiles</h1>
<p align="center">
  trpfrog's dotfiles for macOS and Linux.
</p>

## 📦 Installation

First, clone this repository to **your home directory**.

```bash
cd ~
git clone https://github.com/trpfrog/dotfiles.git
```

### 🍎 macOS

Run the install script.

```bash
~/dotfiles/install.sh
```

### 🐧 Linux

```bash
apt update
apt install -y git zsh
chsh -s $(which zsh)
~/dotfiles/install.sh
```

## 🐸 Scripts

### `install.sh`

This script installs the tools and configurations.

### `install.personal.sh`

This script installs the personal configurations.

### `bin/deploy.sh`

This script creates symbolic links to the home directory.

### Coding-agent commit signing (macOS)

Standard Git/SSH signing settings for Codex and Claude Code, key-loading
helpers, and the macOS login job are restored by `bin/coding-agent-signing install` (also run by `bin/deploy.sh`).
See [migration and key restoration instructions](config/agent-signing/README.md).
Only the public key and 1Password reference are tracked; private keys,
passphrases, and GitHub tokens remain outside this repository.

### `bin/macos.sh`

This script installs configurations for macOS.

## 🛠️ Debug

This repository includes docker-compose file for debugging.

```
docker compose up -d
docker compose exec dotfiles zsh
```
