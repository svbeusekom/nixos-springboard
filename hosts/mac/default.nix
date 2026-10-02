{ self, ... }:
{
  # Assumes Apple Silicon; use x86_64-darwin for Intel Macs.
  nixpkgs.hostPlatform = "aarch64-darwin";
  networking.hostName = "mac";

  system.primaryUser = "svb";
  users.users.svb.home = "/Users/svb";

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.svb = {
    imports = [ self.homeModules.default ];
    home.stateVersion = "26.05";
  };

  system.stateVersion = 6;
}
