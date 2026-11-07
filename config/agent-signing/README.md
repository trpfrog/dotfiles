# Coding-agent commit signing

Commits made from Claude Code and Codex shells are signed with an agent-only
SSH key through the login session's OpenSSH agent.

In a coding agent's shell (`TRPFROG_DOTFILES_AI_AGENT_TYPE` is set), when
`install` in `config.yaml` includes `agent-signing`, `.zshrc` defines a `git`
function that adds the signing settings with `git -c` to each call:
`commit.gpgsign = true`, `gpg.format = ssh`,
`user.signingkey = ~/.ssh/coding-agent-git-signing-key.pub`, and
`gpg.ssh.program = ssh-keygen`. Claude Code does not pass environment variables
from `.zshrc` to its commands, but it does pass shell functions. No app settings
are changed. Only `git` run from the agent's shell is affected; Git run directly
by another program is not.

The key stays in 1Password (**MBP Coding Agent Signing Key** in the Private
vault). `git-agent-unlock` pipes the private key from `op read` straight into
`ssh-add -`, so it is never written to disk, and writes the public key to
`~/.ssh/coding-agent-git-signing-key.pub`. Register that public key once as a
**Signing key** on GitHub so the commits show as Verified.

## Set up a new machine (macOS)

1. Install Git 2.34+, an OpenSSH version supporting SSH signatures,
   1Password, and 1Password CLI. Sign in and enable 1Password CLI integration.
2. Add `agent-signing` to `install` in `config.yaml` and run `install.sh`.
3. Approve the 1Password request, and restart Codex and Claude Code so their
   shells read the new `.zshrc`. To load the key manually, run `git-agent-unlock`.

To turn it off on a machine, leave `agent-signing` out of `config.yaml`.

## What the install item does

`install/agent-signing.sh` links `git-agent-unlock` into `~/.local/bin`, and
copies and loads `net.trpfrog.coding-agent-signing.plist` into
`~/Library/LaunchAgents`, which runs `git-agent-unlock --login` at login.
It does not need 1Password CLI. Running it again is safe.

## Loading and lifecycle

The key is loaded once per login. If it is already loaded, nothing happens.
Otherwise the login job opens 1Password and reads the key, which needs your
approval. If that fails, the job does not retry; run `git-agent-unlock` after
resolving it. Login status and errors are in
`~/Library/Logs/coding-agent-signing.log`.

Loading uses the `SSH_AUTH_SOCK` that the login job inherits from launchd.
Agent shells must use that same standard agent.

No key lifetime is requested, so the key remains loaded until removed or the
agent exits. Locking the Mac or 1Password does not unload it. Same-user
processes with access to the standard agent can use loaded keys. Remove only
the coding key with:

```sh
ssh-add -d ~/.ssh/coding-agent-git-signing-key.pub
```

## GitHub CLI

The macOS shell setup disables the `gh` shell-plugin alias after sourcing
1Password plugins, so other plugins remain available. On a new machine, log in
with `gh auth login` and choose the recommended Git credential-helper setup.
Tokens remain local in Keychain and are not copied into dotfiles.
