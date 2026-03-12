# dotfiles

Declarative system and user configuration using Nix flakes, nix-darwin, and Home Manager.

![Terminal setup](assets/terminal-image.png)

## What this repo manages

- macOS system config (`nix-darwin`) via `darwinConfigurations.personal`
- User programs and dotfiles (`home-manager`) via `homeManagerModules`
- Custom Neovim package (`packages.nvim`) built with `nixvim`

## Current module layout

- `modules/darwin/` -> `flake.darwinModules.*`
- `modules/hosts/<host>/` -> host composition + `flake.darwinConfigurations.*`
- `modules/programs/<category>/` -> `flake.homeManagerModules.*`
  - `modules/programs/terminal/`
  - `modules/programs/internet/` (firefox)
  - `modules/programs/` (shared HM modules like opencode)
- `modules/nix/` -> `flake.nixModules.*`
- `modules/packages/` -> package definitions (`perSystem.packages.*`, e.g. nvim, ptx, ghostty, zsh, tmux, git)

## Key outputs

- `darwinConfigurations.personal`
- `homeManagerModules.*` (all user-facing HM modules)
- `packages.<system>.nvim`

## Bootstrap

Use the setup script:

```bash
./setup.sh
```

`setup.sh` will:

- on macOS, install Determinate Nix (if `nix` is missing)
- set hostname to `personal`
  - macOS: `scutil --set HostName/LocalHostName/ComputerName`
  - Linux: `hostnamectl set-hostname` (if available)
- run system switch for `#personal`

## Manual rebuild

```bash
sudo darwin-rebuild switch --flake ~/git/dotfiles#personal
```

## Secrets (nix-darwin + sops-nix)

- `sops-nix` base config is in `darwinModules.sops`.
- The default encrypted file path is `secrets/secrets.yaml`.
- The default age key file is `~/sops/age/keys.txt`.
- Git signing key material is provisioned to `~/.ssh/git_signing_ed25519` by `sops.secrets.git-signing-key`.
- `nix develop` includes `sops`/`age` and exports `SOPS_AGE_KEY_FILE=~/sops/age/keys.txt`.

## Formatting

After any `.nix` change, run:

```bash
nix fmt .
```
