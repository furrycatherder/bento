{ config, lib, pkgs, ... }:

let

  cfg = config.home;

  files = import ./files.nix {
    inherit pkgs lib;
  };

  secrets = import ./secrets.nix;

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

      home.secrets = mkOption {
        type = with types; attrsOf (submodule secrets);
        default = {};
        description = ''
          Secrets to keep. Note that /nix/store is world-readable, so you will
          want to use environment variables if others have login access to your
          computer.
        '';
      };
    };

    config = {};
  }
