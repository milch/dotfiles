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
    # Import shared configuration
    sharedConfiguration = import ./nix/shared/default.nix;

    system.stateVersion = 5;

    lib = import nixpkgs.lib;

    # Function to create a Darwin system configuration
    mkDarwinSystem = { hostConfig, hostHomeModule ? ./nix/shared/home.nix, system ? "aarch64-darwin" }:
      nix-darwin.lib.darwinSystem {
        inherit system;
        modules = [
          # Import shared configuration
          sharedConfiguration
          # Import host-specific configuration
          hostConfig
          # Home Manager configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # Use shared home-manager config for all hosts
            home-manager.users.manu = hostHomeModule;
          }
        ];
      };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#<hostname>
    darwinConfigurations = {
      # Personal laptop configuration
      "Auri" = mkDarwinSystem {
        hostConfig = import ./nix/hosts/auri/flake.nix;
        hostHomeModule = import ./nix/hosts/auri/home.nix;
      };

      # Example: Add more host configurations as needed
      # "work-laptop" = mkDarwinSystem {
      #   hostConfig = import ./nix/hosts/work-laptop.nix;
      # };
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Auri".pkgs;
  };
}
