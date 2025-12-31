{ config, lib, pkgs, ... }:

{
  accounts.email.accounts."Uni Bonn" = {
    primary = true;

    realName = "Martin Bieker";
    address  = "martin.bieker@uni-bonn.de";
    userName = "mbieker";

    imap = {
      host = "email.uni-bonn.de";
      port = 993;
      tls.enable = true;
    };

    smtp = {
      host = "email.uni-bonn.de";
      port = 465;
      tls.enable = true;
    };

    signature.text =
      ''
      --
      Martin Bieker
      '';

    thunderbird = {
      enable = true;
      profiles = [ "default" ];
    };
  };

  programs.thunderbird = {
    enable = true;

    profiles.default = {
      isDefault = true;
    };
  };

  services.gnome-keyring.enable = true;
}
