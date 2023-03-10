{ pkgs, nixpkgs, system, naersk, rust-overlay }: 
let
  rustPkgs = import nixpkgs {
    inherit system;
    overlays = [ (import rust-overlay) ];
  };

  rustVersion = "1.68.0";

  naerskLib = pkgs.callPackage naersk {};

in {
  gpkg_cli = naerskLib.buildPackage {
    name = "gpkg_cli";
    src = ./.;
    cargoBuildOptions = x: x ++ [ "-p" "gpkg_cli" ];
  };
  gpkg = naerskLib.buildPackage {
    name = "gpkg";
    src = ./.;
    cargoBuildOptions = x: x ++ [ "-p" "gpkg" ];
  };
}