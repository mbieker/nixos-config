{ lib, pkgs, config, ... }: {
  imports = [
    ../home-manager/common.nix
  ];
  home = {
    # Install packages from https://search.nixos.org/packages
    packages = with pkgs; [
      zoom-us
    ];

    username = "msb";
    homeDirectory = "/home/msb";

    stateVersion = "24.11";
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
