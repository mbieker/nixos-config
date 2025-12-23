{ config, pkgs, ... }:

{
  home.packages = with pkgs;[ 
      #Important
      cowsay
      # Communication
      thunderbird
      telegram-desktop
      mattermost-desktop

      # Office
      kdePackages.okular
      libreoffice
      inkscape
      jabref
      typst
      zathura

      # Work
      remmina
      xpra
      nextcloud-client

  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
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

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    git = {
      enable = true;
      settings.user = {
        name = "Martin Bieker";
        email = "martin.bieker@uni-bonn.de";
      };
    };

    emacs = {
      enable = true;
    };

    vscode = {
      enable = true;
      package = pkgs.vscode;
      profiles.default.extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
      ];
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
  
  services = {
    emacs = {
      enable = true;
   };
 };
}
