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
  - `modules/programs/terminal/` (ghostty, tmux, zsh, nu)
  - `modules/programs/internet/` (firefox)
  - `modules/programs/` (shared HM modules like git, opencode, sops)
- `modules/nix/` -> `flake.nixModules.*`
- `modules/packages/` -> package definitions (`perSystem.packages.*`, e.g. nvim and ptx)

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

## Secrets (Home Manager + sops-nix)

- `sops-nix` base config is in `homeManagerModules.sops`.
- The default encrypted file path is `secrets/secrets.yaml`.
- The default age key file is `~/sops/age/keys.txt`.
- Git signing secret wiring lives in `homeManagerModules.git` and uses `sops.secrets.git-signing-key.path`.
- `nix develop` includes `sops`/`age` and exports `SOPS_AGE_KEY_FILE=~/sops/age/keys.txt`.

Shell defaults shared between zsh and nushell live in `programs.shellProfile`.

## Formatting

After any `.nix` change, run:

```bash
nix fmt .
```
