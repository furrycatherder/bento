{ config, pkgs, lib, ... }:

let

  cfg = config.programs.direnv;

in

  {
    options = with lib; {
      programs.direnv = {
        enable = mkEnableOption ''
          Whether to enable direnv, an environment switcher for the shell.
        '';
      };
    };

    config = with lib; mkIf cfg.enable {
      home.files.".zshrc".text = mkIf config.programs.zsh.enable ''
        eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
      '';
    };
  }
