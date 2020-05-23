{ config, lib, pkgs, ... }:

{
  nixpkgs.crossSystem = lib.systems.elaborate lib.systems.examples.aarch64-multiplatform;
  nixpkgs.localSystem.system = builtins.currentSystem or "x86_64-linux";
  networking.hostName = "rpi41";
  nixpkgs.config.allowUnsupportedSystem = true;

  imports = [
    (import <nixpkgs/nixos/modules/profiles/installation-device.nix>)
    (import <nixpkgs/nixos/modules/profiles/base.nix>)
    (import <nixpkgs/nixos/modules/installer/cd-dvd/sd-image.nix>)
  ];

  boot.loader.grub.enable = false;
  boot.loader.raspberryPi.enable = true;
  boot.loader.raspberryPi.version = 4;
  boot.kernelPackages = pkgs.linuxPackages_rpi4;
  boot.consoleLogLevel = lib.mkDefault 7;

  sdImage = {
    firmwareSize = 512;
    # This is a hack to avoid replicating config.txt from boot.loader.raspberryPi
    populateFirmwareCommands = "${config.system.build.installBootLoader} ${config.system.build.toplevel} -d ./firmware";
    # As the boot process is done entirely in the firmware partition.
    populateRootCommands = "";
    compressImage = false;
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
    };
  };
    
  fileSystems."/".options = [ "defaults" "discard" ];

  services.nixosManual.showManual = lib.mkForce false;
    
  hardware.opengl = {
    enable = true;
    setLdLibraryPath = true;
    package = pkgs.mesa_drivers;
  };

  hardware.deviceTree = {
    base = pkgs.device-tree_rpi;
    overlays = [ "${pkgs.device-tree_rpi.overlays}/vc4-fkms-v3d.dtbo" ];
  };

  boot.loader.raspberryPi.firmwareConfig = ''
    gpu_mem=192
  '';
}