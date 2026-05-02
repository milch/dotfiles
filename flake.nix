{
  description = "Dotfile configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      home-manager,
      nix-index-database,
    }:
    let
      mkDarwinSystem =
        {
          hostConfig,
          hostHomeModule ? ./nix/shared/home.nix,
        }:
        nix-darwin.lib.darwinSystem {
          modules = [
            hostConfig
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.manu = hostHomeModule;
            }
            nix-index-database.darwinModules.nix-index
            { programs.nix-index-database.comma.enable = true; }
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
