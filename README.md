# nixos-springboard

A public repository bootstrap to get the right credentials to pull the more elaborate private Nix/NixOS repositories.

Used on a MacBook (Nix package manager) and a Windows laptop under WSL — neither
runs NixOS, so this ships as a **Home Manager module** rather than a NixOS
module. It:

- installs `gh` (the GitHub CLI)
- on every `home-manager switch`, logs `gh` in non-interactively with a
  token, then runs `gh auth setup-git` so git (and therefore Nix flake
  inputs) can authenticate to `github.com`

## Usage

1. Import the module in your Home Manager flake:

   ```nix
   {
     inputs.nixos-springboard.url = "github:<you>/nixos-springboard";

     outputs = { home-manager, nixos-springboard, ... }: {
       homeConfigurations."<user>@<host>" = home-manager.lib.homeManagerConfiguration {
         modules = [ nixos-springboard.homeModules.default ];
       };
     };
   }
   ```

2. Before the first `home-manager switch`, place a GitHub personal access
   token (with `repo` scope) at `~/.gh-token`, readable only by you.
   Provision it out-of-band — e.g. copied manually during setup, or dropped
   in by a secrets manager. It is never committed to this repo or read
   into the Nix store.

   The path can be changed via `services.ghAuth.tokenFile`.
