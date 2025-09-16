{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: 
let
  ts_auth_key = "tskey-auth-kBcZ5xHC7A11CNTRL-YF1nvecDrbFTPf9tq67MhFai7vHvuaNJ";
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
      networking.firewall = {
        enable = true;
        # always allow traffic from your Tailscale network
        trustedInterfaces = [ "tailscale0" ];
        allowedUDPPorts = [ config.services.tailscale.port ];
        # Allow only HTTPS from the outside / SSH goes via tailscale
        allowedTCPPorts = [ 443 ];
      };

      # Tailscale
      services.tailscale.enable = true;

      # create a oneshot job to authenticate to Tailscale
      systemd.services.tailscale-autoconnect = {
        description = "Automatic connection to Tailscale";
        after = [ "network-pre.target" "tailscale.service" ];
        wants = [ "network-pre.target" "tailscale.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig.Type = "oneshot";

        # have the job run this shell script
        script = with pkgs; ''
          # wait for tailscaled to settle
          sleep 2

          # check if we are already authenticated to tailscale
          status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
          if [ $status = "Running" ]; then # if so, then do nothing
            exit 0
          fi

          # otherwise authenticate with tailscale
          ${tailscale}/bin/tailscale up --ssh -authkey ${ts_auth_key}
        '';
      };
    };
  }
  

  

