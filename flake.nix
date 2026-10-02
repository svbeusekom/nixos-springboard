{
  description = "Minimal springboard: installs GitHub CLI and authenticates it automatically, via Home Manager (macOS + Linux/WSL).";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, disko, nixos-wsl, nix-darwin, ... }: {
    nixosConfigurations.f3a = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        ./hosts/f3a
      ];
    };

    nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit self; };
      modules = [
        nixos-wsl.nixosModules.default
        home-manager.nixosModules.home-manager
        ./hosts/wsl
      ];
    };

    darwinConfigurations.mac = nix-darwin.lib.darwinSystem {
      specialArgs = { inherit self; };
      modules = [
        home-manager.darwinModules.home-manager
        ./hosts/mac
      ];
    };

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
