{
  description = "gpkg";

  inputs = {
    naersk.url = "github:nix-community/naersk";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.follows = "rust-overlay/flake-utils";
    nixpkgs.follows = "rust-overlay/nixpkgs";
  };

  outputs = inputs: with inputs;
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        code = pkgs.callPackage ./. { inherit nixpkgs system naersk rust-overlay; };
      in rec {
        packages = {
          gpkg_cli = code.gpkg_cli;
          gpkg = code.gpkg;
          all = pkgs.symlinkJoin {
            name = "gpkg";
            paths = with code; [ gpkg_cli gpkg ];
          };
          default = packages.all;
        };
        defaultPackage = self.packages.${system}.gpkg;
      });
}
