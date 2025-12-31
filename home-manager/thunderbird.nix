{ config, lib, pkgs, ... }:

let
  common = {
  realName = "Martin Bieker";


  thunderbird = {
    enable = true;
    profiles = [ "default" ];
  };
};
  mkSignature = address : {
    showSignature = "attach";
    text =
    ''
      Dr. Martin Bieker, wissenschaftlicher Mitarbeiter
      Universität Bonn, HISKP, AG Thoma
      Kreuzbergweg 24, 53115 Bonn, Deutschland
      Telefon: +49 228 73-69433
      E-Mail: ${address}
      www: https://agthoma.hiskp.uni-bonn.de
      Rheinische Friedrich-Wilhelms-Universität Bonn
      gegründet 1818, Exzellenzuniversität seit 2019
    '';
  };
  in
{
  accounts.email.accounts."Uni Bonn" = rec {
    primary = true;
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
    signature = (mkSignature address);

  } // common;

  accounts.email.accounts."TU Dortmund" = rec {
    primary = false;
    address  = "martin.bieker@tu-dortmund.de";
    userName = "smmnbiek";


    imap = {
      host = "unimail.tu-dortmund.de";
      port = 993;
      tls.enable = true;
    };

    smtp = {
      host = "unimail.tu-dortmund.de";
      port = 465;
      tls.enable = true;
    };
    signature = (mkSignature address);

  } // common;

  accounts.email.accounts."CERN" = rec {
    primary = false;
    address  = "martin.bieker@cern.ch";
    userName = "martin.bieker@cern.ch";


    imap = {
      host = "outlook.office365.com";
      port = 993;
      authentication = "xoauth2";
      tls.enable = true;
    };

    smtp = {
      host = "outlook.office365.com";
      port = 587;
      authentication = "xoauth2";
      tls.enable = true;
    };
    signature = (mkSignature address);

  } // common;

  programs.thunderbird = {
    enable = true;

    profiles.default = {
      isDefault = true;
    };
  };

  services.gnome-keyring.enable = true;
}
