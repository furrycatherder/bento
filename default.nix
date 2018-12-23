{ configuration ? builtins.getEnv "HOME" + "/.config/nixpkgs/stow.nix"
, pkgs ? import <nixpkgs> {}
, lib ? pkgs.stdenv.lib }:

let

  overlays = import ./overlays; # TODO: modules should get overlayed pkgs

  modules = import ./modules {
    inherit pkgs lib configuration;
  };

  finalModules = lib.evalModules {
    inherit modules;
  };

in

  rec {
    inherit (finalModules) options config;
    inherit overlays;

    stow =
        let

          mkLinkFarmEntry = file: {
            name = file.target;
            path = file.source;
          };

          files = lib.attrValues config.home.files;

        in

          pkgs.linkFarm "stow-env" (map mkLinkFarmEntry files);

    nix-stow = pkgs.callPackage ./nix-stow {};
  }
