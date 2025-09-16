{
  imports = [
    # Paths to other modules.
    # Compose this module out of smaller ones.
  ];

  options = {
    # Option declarations.
    # Declare what settings a user of this module can set.
    # Usually this includes a global "enable" option which defaults to false.
  };

  config = {
  
    services.paperless = {
      enable = true;
      port = 8888;

      consumptionDirIsPublic = false;
      settings = {
        PAPERLESS_OCR_LANGUAGE = "deu+eng";
        PAPERLESS_OCR_USER_ARGS = {
          optimize = 1;
          pdfa_image_compression = "lossless";
        };
      };
    };

    # Webserver
    services.caddy.virtualHosts."paperless.msb.wtf".extraConfig = ''
        reverse_proxy :8888
    '';
  };
}