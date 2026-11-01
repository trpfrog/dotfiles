# Coding-agent commit signing

Codex and Claude Code use standard Git SSH signing with the login session's
OpenSSH agent. They select the agent-only public key directly with
`user.signingkey = "key::ssh-ed25519 ..."` and use `gpg.ssh.program = "ssh-keygen"`.
There is no custom signing executable, private SSH agent, or fixed socket path.
Ordinary interactive Git retains its existing signing configuration.

## Restore on a new machine

1. Install Git 2.34+, an OpenSSH version supporting SSH signatures, Python 3,
   1Password, and 1Password CLI. Sign in and enable 1Password CLI integration.
2. Open **MBP Coding Agent Signing Key** in the Private vault. Export its private
   key as **OpenSSH**, using **Download Encrypted Key** and the passphrase in
   **Exported Passphrases** referenced by `settings.json`. Save it to
   `~/.ssh/coding-agent-git-signing-key`, then run:

   ```sh
   chmod 600 ~/.ssh/coding-agent-git-signing-key
   ```

   Keep the key encrypted and outside this repository. Its public key is tracked
   here; reusing the key does not require a new GitHub registration.
3. On macOS, deploy the dotfiles normally, or install only this setup:

   ```sh
   ~/dotfiles/bin/coding-agent-signing install
   ```

   On Linux, run the same installer with `--no-launch` from an existing SSH
   agent session. It installs app settings and helpers, but no macOS login job.
   Use your desktop/session manager's standard SSH agent; this setup does not
   start an additional agent.
4. Approve the 1Password request if one appears, and restart Codex and Claude
   Code. To load the key manually using 1Password, run `git-agent-unlock`.
   Ordinary `ssh-add ~/.ssh/coding-agent-git-signing-key` works too, and prompts
   for the passphrase interactively.

## Standard app settings

The installer merges only standard Git environment variables
(`GIT_CONFIG_COUNT`, `GIT_CONFIG_KEY_n`, and `GIT_CONFIG_VALUE_n`) into the apps'
normal environment settings:

- Codex: `[shell_environment_policy.set]` in `~/.codex/config.toml`.
- Claude Code: `env` in `~/.claude/settings.json`.

Both get identical values. No home paths or SSH agent socket paths are written
into these settings, and no aliases or agent-specific hooks are required.
The explicit `ssh-keygen` value overrides interactive Git's 1Password signer.
Other settings, hooks, and permissions remain untouched. The shared Codex
config remains independently managed by `bin/codex-config`.

The installer links only the two loading helpers into `~/.local/bin` and links
the public key into `~/.ssh`. On macOS, it generates and loads
`~/Library/LaunchAgents/net.trpfrog.coding-agent-signing.plist` for login-time
loading. `--no-launch` writes settings without loading the job. Reinstallation
also migrates the earlier dedicated-signer settings and removes its symlink.

## Loading and lifecycle

`settings.json` stores only a 1Password secret reference, never the passphrase.
The askpass helper passes the value directly from `op read` to `ssh-add`; do not
run `git-signing-passphrase` directly, since its stdout is the passphrase.
No passphrase is placed in command arguments, environment variables, or logs.

Loading uses the inherited `SSH_AUTH_SOCK`. macOS login jobs normally inherit
the standard socket from launchd; if absent, the login loader asks launchd for
it. No socket is hardcoded or written into app settings. Codex and Claude Code
must inherit access to that same standard agent. Agent forwarding is neither
needed nor enabled.

An already-loaded key is left alone. Otherwise the login loader opens
1Password on macOS and requests the stored passphrase. If 1Password is not
ready, access is denied, the agent is unavailable, or the key has not been
restored, the job fails once without repeatedly prompting. Run
`git-agent-unlock` after resolving it. Non-secret login status/errors are under
`~/Library/Logs/CodingAgentSigning/` on macOS.

No key lifetime is requested. With the macOS standard agent's default settings,
the key remains loaded until removed or the agent exits. Locking the Mac or
1Password does not unload it. Same-user processes with access to the standard
agent can use loaded keys. Remove only the coding key with:

```sh
ssh-add -d ~/.ssh/coding-agent-git-signing-key.pub
```

## GitHub CLI

The macOS shell setup disables the `gh` shell-plugin alias after sourcing
1Password plugins, so other plugins remain available. On a new machine, log in
with `gh auth login` and choose the recommended Git credential-helper setup.
Tokens remain local in Keychain and are not copied into dotfiles.
