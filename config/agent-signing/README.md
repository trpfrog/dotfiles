# Coding-agent commit signing (macOS)

This setup lets Codex and Claude Code run ordinary `git commit` commands with
an agent-only SSH signing key. Interactive Git keeps its existing signing
configuration. A dedicated OpenSSH agent holds the unlocked key without a time
limit. macOS login and `git-agent-unlock` both load it through 1Password CLI.

## Restore on a new Mac

1. Install and sign in to 1Password and 1Password CLI. In 1Password, enable
   **Settings > Developer > Integrate with 1Password CLI**.
2. Open **MBP Coding Agent Signing Key** in the Private vault. Export its private
   key as **OpenSSH**, using **Download Encrypted Key** and the passphrase in
   **Exported Passphrases** referenced by `settings.json`. Save it to
   `~/.ssh/coding-agent-git-signing-key`, then run:

   ```sh
   chmod 600 ~/.ssh/coding-agent-git-signing-key
   ```

   Keep the key encrypted and outside this repository. Its public key is tracked
   here and installed separately; reusing this key does not require registering
   another signing key on GitHub.
3. Deploy the dotfiles normally, or install only this setup:

   ```sh
   ~/dotfiles/bin/coding-agent-signing install
   ```

4. Approve the 1Password request if one appears, and restart Codex and Claude
   Code. To load the key manually, run `~/.local/bin/git-agent-unlock`.

The installer merges only the signing environment variables into
`~/.codex/config.toml` and `~/.claude/settings.json`. It preserves other settings
and links the three helpers into `~/.local/bin`. It generates and loads
`~/Library/LaunchAgents/net.trpfrog.coding-agent-signing.plist` using the current
home directory. `--no-launch` writes the files without loading the login job.

The shared Codex config remains managed independently by `bin/codex-config`.
The signing setup is macOS-only and is not applied to Linux by `bin/deploy.sh`.

## Authentication and lifecycle

`settings.json` stores only a 1Password secret reference, never the passphrase.
The askpass helper passes the value directly from `op read` to `ssh-add`; do not
run `git-signing-passphrase` directly, since its stdout is the passphrase.
No passphrase is placed in command arguments, environment variables, or logs.

At login, an already-loaded key is left alone. Otherwise the script opens
1Password, waits briefly for it to start, and requests the stored passphrase.
If 1Password is not ready, access is denied, or the key has not been restored,
the login job fails once without repeatedly prompting. Run `git-agent-unlock`
after resolving it. Non-secret status/errors are under
`~/Library/Logs/CodingAgentSigning/`.

Unlocking still may require 1Password approval. After loading, locking the Mac
or 1Password does not unload the key; same-user processes with access to the
socket can sign until the agent exits. The socket is
`~/.ssh/agent-signing/agent.sock`. To remove only this key from the running agent:

```sh
SSH_AUTH_SOCK="$HOME/.ssh/agent-signing/agent.sock" \
  ssh-add -d "$HOME/.ssh/coding-agent-git-signing-key.pub"
```

## GitHub CLI

The macOS shell setup disables the `gh` shell-plugin alias after sourcing
1Password plugins, so other plugins remain available. On a new machine, log in
with `gh auth login` and choose the recommended Git credential-helper setup.
Tokens remain local in Keychain and are not copied into dotfiles.
