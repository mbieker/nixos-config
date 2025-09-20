{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: 
let
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
    # HTTPS Loadbalancer and Certificate manager
    # Certificates from Let's Encrypt 
    services.caddy = { 
      enable = true;
      package = pkgs.caddy.withPlugins {
          plugins = [ "github.com/caddy-dns/desec@v1.0.1" ];
	  hash = "sha256-H8G67gJefBBNRMCsaAL29H5OJJ73+qZAepjbPOAtOck=";
      };
      #acmeCA = "https://acme-staging-v02.api.letsencrypt.org/directory";
      acmeCA = "https://acme-v02.api.letsencrypt.org/directory";
      email = "martin.bieker@udo.edu";
      logFormat = "level DEBUG";
      globalConfig = 
      ''
      	acme_dns desec {
	  	    token "Soh7nyFLyAoPJLkTaarAZVe9nkXW"
	    }
      '';
    };

    # Local / tailnet internal DNS server
    services.coredns = {
      enable = true;
      config =
      ''
      . {
          template IN A msb.wtf {
          answer "{{.Name}} 60 IN A 100.87.235.41"
        }
        template IN AAAA msb.wtf {
            rcode NOERROR
          }
      
        forward . 8.8.8.8
        cache 30
        log
      }
      '';
    };
  };
}
