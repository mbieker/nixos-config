# /etc/nixos/flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    docspell.url = "github:eikek/docspell";
    docspell.inputs.nixpkgs.follows = "nixpkgs";

    caddy.url = "github:vincentbernat/caddy-nix";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url= "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
      {
        nixosConfigurations.msb-t14 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./msb-t14
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.msb = import ./msb-t14/home.nix;
            }
            {
	            nixpkgs.overlays = [
                (final: prev: {
                  cosmic-session = prev.cosmic-session.overrideAttrs (oldAttrs: {
                    postPatch = (oldAttrs.postPatch or "") + ''
              substituteInPlace data/start-cosmic \
                --replace-fail '/keyring/ssh' '/gcr/ssh'
            '';
                  });
                })
              ];
            }
          ];
        };

        nixosConfigurations.vps = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            {
	            nixpkgs.overlays = [
		            inputs.docspell.overlays.default
	            ];
	          }
            inputs.disko.nixosModules.disko
            inputs.docspell.nixosModules.default
            ./vps
          ];
        };

        homeConfigurations."msb-t14" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [ ./home-manager/msb-t14.nix ];
        };
        homeConfigurations."work" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [./home-manager/home.nix];
        };
      };
}
