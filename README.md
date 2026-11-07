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

Then copy `config.example.yaml` to `~/dotfiles/config.yaml` and edit it for this machine.
This file is ignored by Git. See [Machine-specific settings](#-machine-specific-settings).

```bash
cp ~/dotfiles/config.example.yaml ~/dotfiles/config.yaml
```

### 🍎 macOS

Run the install script.

```bash
~/dotfiles/install.sh
```

To use a config stored somewhere else, pass its path.

```bash
~/dotfiles/install.sh path/to/config.yaml
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

This script runs `bin/deploy.sh`, then runs each item in `install` of the config (`install/<item>.sh`) in order.
Without a config, it only runs `bin/deploy.sh`.
If the config has a problem, it stops before doing anything.

### `bin/deploy.sh`

This script creates symbolic links to the home directory, includes the shared `.gitconfig`,
and writes `git.name` / `git.email` of the config to `~/.gitconfig`.
It also links each coding-agent skill in `skills/<name>` into `~/.claude/skills` and `~/.codex/skills`,
only for the agents whose directory exists. Other skills already in those directories are kept.
It only does things that are safe on any machine.

## 🧠 Agent skills

`skills/` holds general-purpose agent skills, laid out as `skills/<name>/SKILL.md`
following the [Agent Skills specification](https://agentskills.io/specification).

| Skill | What it does |
|---|---|
| `diagram-for-review` | Draws Mermaid diagrams for code review, written so each node reads on its own |
| `review-comments` | Checks code comments in a change: written for future readers, not reviewers, and not repeating the code |

To use them without these dotfiles, install them with the GitHub CLI (preview) or the `skills` CLI:

```sh
gh skill install TrpFrog/dotfiles diagram-for-review --agent claude-code --scope user
npx skills add TrpFrog/dotfiles --skill diagram-for-review -g
```

On machines with these dotfiles, `bin/deploy.sh` links them instead, so edits apply immediately.

## 🧩 Machine-specific settings

The shared configuration does not know which machine it runs on.
Settings for each machine are written in one file outside this repository:
`$DOTFILES_CONFIG`, or `~/dotfiles/config.yaml` by default.
To keep it in another repository, set `DOTFILES_CONFIG` or symlink it to `~/dotfiles/config.yaml`.

```yaml
install:          # install items, run in order (install/<item>.sh)
  - homebrew
  - sheldon
git:
  name: your-name
  email: "you@example.com"
```

- The file is read by `lib/config.zsh` with zsh builtins only, so it works on a fresh machine without extra tools.
  It accepts a subset of YAML: 2-space indents, up to 2 levels of nesting, `- value` lists, and `[]` for an empty list. Anything else is an error.
- **Brewfile**: `homebrew.brewfile` selects the Brewfile for this machine. `install.sh` runs `brew bundle` with it, and it is rewritten after every `brew install` / `uninstall`. The recommended value is `~/dotfiles/config/Brewfile`, but there is no default: nothing is installed unless you set it, so another machine's packages are never installed by accident.
- `config.schema.json` gives completion and type checks in editors (for example, VS Code with the YAML extension).
- See [install](install/README.md) for the available install items.

### Coding-agent commit signing (macOS)

Commits from Claude Code and Codex shells are signed with an agent-only SSH key
kept in 1Password (set in `.zshrc`). The key-loading helper and the macOS login job are restored
by the `agent-signing` install item.
See [setup instructions](config/agent-signing/README.md).
Only the 1Password reference is tracked; private keys
and GitHub tokens remain outside this repository.

### `bin/macos.sh`

This script applies macOS settings. It is run by `bin/deploy.sh` on macOS.

## 🛠️ Debug

This repository includes docker-compose file for debugging.

```
docker compose up -d
docker compose exec dotfiles zsh
```
