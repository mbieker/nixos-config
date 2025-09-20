# Thes is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: 
let 
in
{
  # You can import other NixOS modules here
  imports = [
     ./disk-config.nix
     ./hardware-configuration.nix
    ../modules/networking.nix
    ../modules/webserver.nix
    ../modules/docspell.nix
    ../modules/paperless.nix
    ../modules/syncthing.nix
  ];

  nix.settings.experimental-features = "nix-command flakes";

  # Networking
  networking.hostName = "vps";
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  networking.interfaces.ens3.ipv4.addresses = [ {
    address = "178.254.36.175";
    prefixLength = 22;
    } ];
  networking.defaultGateway = "178.254.36.1";
  networking.nameservers = [ "178.254.16.151" "178.254.16.141" ];
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.efiSupport = true;
  boot.loader.timeout = 2;
   time.timeZone = "Europe/Berlin";


   i18n.defaultLocale = "en_US.UTF-8";
   console = {
     font = "Lat2-Terminus16";
    # keyMap = "de";
     useXkbConfig = true; # use xkb.options in tty.
   };

  services.xserver.enable = false;

  users.users = {
    mbieker = {
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
	"ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBIUmAc1Ju8VVUCs/Ryap1FIAphlyRCQ1CkPGZfjSG2/64ilVHstHZgZZk1cJ3yEYNl4RI6tPPVTuRaH5Wia77/8= mbieker@arch-t14"
      ];
      extraGroups = ["wheel"];
    };
  };
  environment.systemPackages = with pkgs; [
    vim 
    wget
    curl
    git
    cowsay
  ];

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "yes";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
    };
  };


  system.stateVersion = "24.11";
}
