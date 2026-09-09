{
  description = "Minimal springboard: installs GitHub CLI and authenticates it automatically, via Home Manager (macOS + Linux/WSL).";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }: {
    homeModules.default = { config, lib, pkgs, ... }:
      let
        cfg = config.services.ghAuth;
      in
      {
        options.services.ghAuth.tokenFile = lib.mkOption {
          type = lib.types.path;
          default = "${config.home.homeDirectory}/.gh-token";
          description = ''
            Path to a file containing a GitHub personal access token.
            Must be provisioned out-of-band (e.g. copied manually, or via a
            secrets manager) before the first activation. Never committed
            to this repo and never read into the Nix store.
          '';
        };

        config = {
          home.packages = [ pkgs.gh ];

          # Runs on every `home-manager switch`, as the user, on both
          # macOS and Linux (including WSL) — no systemd/launchd needed.
          home.activation.ghAuth = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            if ! $DRY_RUN_CMD ${pkgs.gh}/bin/gh auth status >/dev/null 2>&1; then
              $DRY_RUN_CMD ${pkgs.gh}/bin/gh auth login --with-token < ${cfg.tokenFile}
              $DRY_RUN_CMD ${pkgs.gh}/bin/gh auth setup-git
            fi
          '';
        };
      };
  };
}
