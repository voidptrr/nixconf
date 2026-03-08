#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOST="personal"

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "error: missing required command: $1" >&2
    exit 1
  }
}

ensure_nix() {
  if command -v nix >/dev/null 2>&1; then
    return
  fi

  echo "Installing Determinate Nix..."
  need_cmd curl
  curl --proto '=https' --tlsv1.2 -sSfL https://install.determinate.systems/nix | sh -s -- install --no-confirm

  if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
    # shellcheck disable=SC1091
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  fi
}

setup_darwin() {
  ensure_nix
  need_cmd nix
  need_cmd scutil
  need_cmd sudo
  need_cmd darwin-rebuild

  echo "Using host: $HOST"
  sudo scutil --set HostName "$HOST"
  sudo scutil --set LocalHostName "$HOST"
  sudo scutil --set ComputerName "$HOST"

  sudo darwin-rebuild switch --flake "${ROOT_DIR}#${HOST}"
}

setup_linux() {
  need_cmd sudo

  if ! command -v nixos-rebuild >/dev/null 2>&1; then
    echo "nixos-rebuild not found; skipping system switch on Linux."
    return
  fi

  echo "Using host: $HOST"
  if command -v hostnamectl >/dev/null 2>&1; then
    sudo hostnamectl set-hostname "$HOST"
  fi

  sudo nixos-rebuild switch --flake "${ROOT_DIR}#${HOST}"
}

main() {
  case "$(uname -s)" in
    Darwin)
      setup_darwin
      ;;
    Linux)
      setup_linux
      ;;
    *)
      echo "Unsupported OS: $(uname -s)" >&2
      exit 1
      ;;
  esac
}

main "$@"
