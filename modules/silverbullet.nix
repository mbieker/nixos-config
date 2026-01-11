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
  
    services.silverbullet = {
      enable = true;
      listenPort = 8888;
      };

    # Webserver
    services.caddy.virtualHosts."sb.msb.wtf".extraConfig = ''
        reverse_proxy :3000
    '';
};
}
