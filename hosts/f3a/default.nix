{ pkgs, ... }:
{
  imports = [ ./disko.nix ];

  networking.hostName = "f3a";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Ryzen AI 9 HX 370 (Strix Point) needs a recent kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-amd" ];

  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  networking.networkmanager.enable = true;
  services.openssh.enable = true;

  users.users.svb = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  environment.systemPackages = [ pkgs.git pkgs.gh ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "26.05";
}
