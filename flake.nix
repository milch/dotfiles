{
  description = "Dotfile configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    mkDarwinSystem = { hostConfig, hostHomeModule ? ./nix/shared/home.nix }:
      nix-darwin.lib.darwinSystem {
        modules = [
          hostConfig
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.manu = hostHomeModule;
          }
        ];
      };
  in
  {
    darwinConfigurations = {
      "Auri" = mkDarwinSystem {
        hostConfig = import ./nix/hosts/auri/flake.nix;
        hostHomeModule = import ./nix/hosts/auri/home.nix;
      };
    };

    darwinPackages = self.darwinConfigurations."Auri".pkgs;
  };
}
