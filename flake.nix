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
      url = "github:nix-community/home-manager";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, ... }@inputs: {
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
  };
}
