{ self, ... }:
{
  networking.hostName = "wsl";

  wsl.enable = true;
  wsl.defaultUser = "svb";

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.svb = {
    imports = [ self.homeModules.default ];
    home.stateVersion = "26.05";
  };

  system.stateVersion = "26.05";
}
