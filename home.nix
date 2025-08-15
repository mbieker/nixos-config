{ lib, pkgs, ... }: {
  home = {
    # Install packages from https://search.nixos.org/packages
    packages = with pkgs; [
      zoom-us
      cowsay
      thunderbird
      telegram-desktop
      mattermost-desktop
      inkscape
      expect
      nextcloud-client
      jabref
      vscode
      poetry
      remmina
      kdePackages.okular
      libreoffice
    ];

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
}
