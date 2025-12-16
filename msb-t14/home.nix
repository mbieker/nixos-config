{ lib, pkgs, config, ... }: {
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
      typst
      tinymist
      tree-sitter-grammars.tree-sitter-typst
      ltex-ls-plus
      zathura

      # Work
      remmina
      nextcloud-client

    ];

    # Dotfiles
    file = {
      ".config/doom" = {
        source = ../home-manager/doom;  # local directory in your repo
        recursive = true;    # important! handles directories
      };

      ".ssh/config" = {
        source = ../home-manager/ssh/config;
      };

      ".ssh/config_e5" = {
        source = ../home-manager/ssh/config_e5;
      };
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

    emacs = {
      enable = true;
    };

    zsh = {
      enable = true;

      shellAliases = {
        ec = "emacsclient";
        vi = "emacsclient";
      };

      sessionVariables = {
        EDITOR="emacsclient";
      };

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
	  id = "hw99d-upwdv";
          path = "/home/msb/org";
          devices = [ "vps" "Pixel 6" ];
        };
      };
    };
  };
}
