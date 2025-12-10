# /etc/nixos/flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    docspell.url = "github:eikek/docspell";
    #docspell.follows = "nixpkgs";

    caddy.url = "github:vincentbernat/caddy-nix";
    #caddy.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
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
        modules = [./home-manager/work.nix];
  };
};
}
