{ configuration ? builtins.getEnv "HOME" + "/.config/bento"
, pkgs ? import <nixpkgs> {}
, lib ? pkgs.stdenv.lib }:

let

  overlays = import ./overlays;

  pkgsWithOverlays = import pkgs.path { inherit overlays; };

  finalModules = lib.evalModules {
    modules = import ./modules { inherit configuration; };
    specialArgs = { pkgs = pkgsWithOverlays; };
  };

in

  rec {
    inherit (finalModules) options config;
    inherit overlays;

    stow =
        let

          files = builtins.filter (f: f.source != null) (
            lib.attrValues config.home.files
          );

        in

          pkgsWithOverlays.mergeFiles "bento-user-home"
            (map (builtins.getAttr "source") files);

    bento = pkgs.callPackage ./bento {};
  }
