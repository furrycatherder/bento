with import <nixpkgs> {};

let
  pkgsWithOverlays = import pkgs.path {
    overlays = import ./overlays;
  };

  finalModules = lib.evalModules {
    modules = import ./modules;
    specialArgs = { pkgs = pkgsWithOverlays; };
  };

  mkLinkFarmEntry = file: {
    name = file.target;
    path = file.source;
  };

  files = builtins.filter (f: f.source != null) (
    lib.attrValues finalModules.config.home.files);

in {
  inherit (finalModules) options config;
  overlays = import ./overlays;

  stow = pkgs.linkFarm "stow-env" (map mkLinkFarmEntry files);

  bento = pkgs.callPackage ./bento {};
}
