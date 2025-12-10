# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:


{
  imports = [
  ./hardware-configuration.nix
  ];
  # Bootloader.
  boot.loader = {
    efi.canTouchEfiVariables = true;
      grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = false;
      default = "saved";
      extraEntries = ''
      menuentry 'Windows Boot Manager (on /dev/nvme0n1p1)' --class windows --class os $menuentry_id_option 'osprober-efi-90D5-2798' {
	savedefault
	insmod part_gpt
	insmod fat
	search --no-floppy --fs-uuid --set=root 90D5-2798
	chainloader /EFI/Microsoft/Boot/bootmgfw.efi
      }
      menuentry 'Arch Linux (on /dev/nvme0n1p4)' --class arch --class gnu-linux --class gnu --class os $menuentry_id_option 'osprober-gnulinux-simple-8795cbb5-510d-4af3-8d42-e56ec2abcac3' {
      	savedefault
      	insmod part_gpt
      	insmod fat
      	search --no-floppy --fs-uuid --set=root 90D5-2798
      	linux /vmlinuz-linux root=/dev/nvme0n1p4
      	initrd /initramfs-linux.img
      }
      '';
    };
  };
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  swapDevices = [{
    device = "/swapfile";
    size = 16 * 1024; # 16GB
  }];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  


  networking.hostName = "msb-t14"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.hosts = {
  "10.101.36.8" = [ "gitlab-ce.agthoma.hiskp" ] ;
  };


  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = [
    pkgs.networkmanager-openvpn
  ];

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Budgie Desktop environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "client";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  hardware.sane.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.ollama = {
    enable = true;
    host = "0.0.0.0";
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.msb = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Martin Bieker";
    extraGroups = [ "networkmanager" "wheel" "scanner" "lp" "docker" "tss" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  
  programs.zsh.enable = true;
 
# GnuPG
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

security.tpm2.enable = true;
security.tpm2.pkcs11.enable = true;  # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
security.tpm2.tctiEnvironment.enable = true;  # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor= true;
  };
  programs.ausweisapp.enable = true;
  programs.ausweisapp.openFirewall = true;
  services.pcscd.enable = true;

  services.dnsmasq = {
    enable = false;
    settings = {
        interface = [ "enp7s0f4u2" ];
    	bind-interfaces = true;
	dhcp-authoritative = true;
       dhcp-range = [ "192.168.1.100,192.168.1.200,1h" ];
     };
   };

 # Fonts

# 24.11 (or earlier)
fonts.packages = with pkgs; [
  nerd-fonts.symbols-only
];


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  gnomeExtensions.pop-shell
  networkmanager-openconnect
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # services.paperless.enable = true;
  # services.paperless.address = "0.0.0.0";

  virtualisation.docker.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
  nix.extraOptions = ''
    extra-substituters = https://devenv.cachix.org
    extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
  '';

}
