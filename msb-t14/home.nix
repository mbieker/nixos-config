{ lib, pkgs, ... }: {
  home = {
    # Install packages from https://search.nixos.org/packages
    packages = with pkgs; [
      #Important
      cowsay
      # Communication
      thunderbird
      telegram-desktop
      mattermost-desktop
      zoom-us

      # Office
      kdePackages.okular
      libreoffice
      inkscape
      jabref

      # Work
      remmina
      nextcloud-client

    ];

    # Dotfiles
    file.".config/doom" = {
      source = ../home-manager/doom;  # local directory in your repo
      recursive = true;    # important! handles directories
    };

    # This needs to be set to your actual username.
    username = "msb";
    homeDirectory = "/home/msb";

    # Don't ever change this after the first build.
    # It tells home-manager what the original state schema
    # was, so it knows how to go to the next state.  It
    # should NOT update when you update your system!
    stateVersion = "24.11";
  };
  programs = {
    git = {
      enable = true;
      userName = "Martin Bieker";
      userEmail = "martin.bieker@udo.edu";
    };

    zsh = {
      enable = true;

      oh-my-zsh = {
        enable = true;
        theme = "agnoster";
        plugins = [
          "sudo"
          "git"
        ];
      };
    };
  };

  services.emacs.enable = true;
  services.syncthing = {
    enable = true;
    settings = {
      gui = {
        user = "mbieker";
        pw = "syncpw";
      };
      devices = {
        "vps"     = { id = "QDEC4DC-Y7EFCC3-VYHLP3I-ZYBH3CC-K53PJHG-35OFWXM-VRFEHQK-WEWYCAP"; };
        "Pixel 6" = { id = "AFZXF6U-Q372KMD-OYVKW3S-AGKU65R-ZX6EDOW-H5GYNIM-DU6DHO4-WMUYRQE"; };
      };
      folders = {
        "org-files" = {
          path = "/home/msb/org";
          devices = [ "vps" "Pixel 6" ];
        };
      };
    };
  };
}
