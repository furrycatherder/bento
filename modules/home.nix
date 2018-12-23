{ config, lib, pkgs, ... }:

let

  cfg = config.home;

  files = import ./files.nix {
    inherit pkgs lib;
  };

in

  {
    options = with lib; {
      home.files = mkOption {
        type = with types; attrsOf (submodule files);
        default = {};
        description = ''
          Files to create in the user's home environment.
        '';
      };
    };

    config = {};
  }
