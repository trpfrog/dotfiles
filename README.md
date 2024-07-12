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
~/dotfiles/installer/install.sh
```

## 🛠️ Debug

This repository includes docker-compose file for debugging.

```
docker compose up -d
docker compose exec dotfiles zsh
```
