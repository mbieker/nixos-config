{ config, pkgs, ... }:

{

  imports = [
    ../home-manager/common.nix
  ];
  
  home.username = "mbieker";
  home.homeDirectory = "/home/mbieker";

  home.stateVersion = "25.05"; # Please read the comment before changing.


  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    services.syncthing.enable = true;
}
