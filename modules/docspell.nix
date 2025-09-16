{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: 
let
  db_config = {
      url = "jdbc:postgresql://localhost:5432/docspell";
      user = "docspell";
      password = "docspell"; 
    };
  full-text-search = {
    enabled = true;
    backend = "postgresql";
    postgresql.use-default-connection = true;
  };
in
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
    #REST Server
    services.docspell-restserver = {
      enable = true;
      base-url = "https://docspell.msb.wtf";
      bind = {
        address = "127.0.0.1";
        port = 7880;
      };
      auth = {
        server-secret = ''b64:uRoCMlgCdAxRK8eilYVo0//z48iQBnhw8vsGXEy69jteeGsY+wAzPiRf3wZKlLLKH94/Ao7638rf
  5ul0Lhs+BL18bCuo8R/394vzACO6nf6Ha91UQQzOV3fbsi3Ggp/PVaj5WrvMK9ZSrGQl43eLIrU+
  vNLmeDrzbXlZqhNXyq0='';
      };
      backend = {
        signup = {
          mode = "invite";
          new-invite-password = "dsinvite2";
          invite-time = "30 days";
        };
        jdbc = db_config;
      };
      inherit full-text-search;
    };

    #Job Excecutor for background tasks
    services.docspell-joex = {
      enable = true;
      base-url = "http://localhost:7878"; 
      bind = {
        address = "localhost";
        port = 7878;
      };
      scheduler = {
        pool-size = 1;
      };
      jdbc = db_config;
      inherit full-text-search;
    };


    # Database
    services.postgresql =
    let
      pginit = pkgs.writeText "pginit.sql" ''
        CREATE USER ${db_config.user} WITH PASSWORD '${db_config.password}' LOGIN CREATEDB;
        GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ${db_config.user};
        GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO ${db_config.user};
        CREATE DATABASE DOCSPELL OWNER '${db_config.user}';
      '';
    in {
        enable = true;
        package = pkgs.postgresql_14;
        enableTCPIP = true;
        initialScript = pginit;
        settings.port = 5432;
        authentication = ''
          local all  all trust
          host  all  all 0.0.0.0/0 md5
	        local replication all peer 
        '';
    };
  
    # Webserver
    services.caddy.virtualHosts."docspell.msb.wtf".extraConfig = ''
        reverse_proxy :7880
    '';
  }; 
}
