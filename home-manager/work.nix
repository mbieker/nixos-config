{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mbieker";
  home.homeDirectory = "/home/mbieker";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs;[ 
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
      zathura

      # Work
      remmina
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
  
  services.syncthing.enable = true;
}
