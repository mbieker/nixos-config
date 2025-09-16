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
    services.syncthing = {
      enable = true;
      openDefaultPorts = true;
      settings = {
        gui = {
          user = "mbieker";
          password = "syncpw";
        };
        devices = {
          "msb-t14" = { id = "L7Z5LFD-QA2OWEV-AKOZDSD-IOEROLC-C5MXDV4-26DNOZD-QUIQT46-ZLQL5AP"; };
          "Pixel 6" = { id = "AFZXF6U-Q372KMD-OYVKW3S-AGKU65R-ZX6EDOW-H5GYNIM-DU6DHO4-WMUYRQE"; };
          "win-pc-01" = { id = "KC6AOXY-EZRD7RI-ZY652CF-R6SKMPD-E5BEW5K-RWBRSMA-2OEGB52-23S5RQ7"; };
        };
      };
    };
  };
}
