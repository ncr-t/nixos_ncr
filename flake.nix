{
  description = "NixOS configuration with flakes";
  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    ecsls.url = "github:Sigmapitech/ecsls";
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
  with inputs; let
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
  in
  {
  formatter.${system} = pkgs.nixpkgs-fmt;
    nixosConfigurations.Onslaught = nixpkgs.lib.nixosSystem {
      modules = [
        nixos-hardware.nixosModules.lenovo-thinkpad-t490
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.ncr = import ./home.nix;
          home-manager.extraSpecialArgs = {
          inherit ecsls system;
          };
        }
      ];
    };
  };
}
