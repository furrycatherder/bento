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
        _direnv_hook() {
          eval "$("${pkgs.direnv}/bin/direnv" export zsh)";
        }
        typeset -ag precmd_functions;
        if [[ -z ''${precmd_functions[(r)_direnv_hook]} ]]; then
          precmd_functions+=_direnv_hook;
        fi
      '';
    };
  }
