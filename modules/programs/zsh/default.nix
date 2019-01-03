{ config, pkgs, lib, ... }:

let

  cfg = config.programs.zsh;

  oh-my-zsh = import ./oh-my-zsh.nix {
    inherit pkgs lib;
  };

  allPlugins = cfg.oh-my-zsh.plugins
    ++ map (p: p.name) cfg.oh-my-zsh.customPlugins;

in

  {
    options = with lib; {
      programs.zsh = {
        enable = mkEnableOption ''
          Whether to enable zsh, the Z shell.
        '';

        # shadows the --with-zprofile configure option
        zprofile = mkOption {
          type = types.path;
          default = "/etc/zprofile";
          description = ''
            Path to the system zprofile.
          '';
        };

        extraConfig = mkOption {
          type = types.lines;
          default = "";
          description = ''
            Extra configuration lines to put in zshrc.
          '';
        };

        oh-my-zsh = mkOption {
          type = types.submodule oh-my-zsh;
          default = {};
          description = ''
            Configuration options for Oh My Zsh.
          '';
        };
      };
    };

    config = with lib; mkIf cfg.enable {
      home.files.".zshenv".text = optionalString cfg.oh-my-zsh.enable ''
        ZSH="${pkgs.oh-my-zsh}/share/oh-my-zsh"
        ZSH_CUSTOM="${toString cfg.oh-my-zsh.custom}"
        ZSH_CACHE_DIR="$HOME/.cache/oh-my-zsh"
        DISABLE_AUTO_UPDATE="true"
      '';

      home.files.".zshrc".text = optionalString cfg.oh-my-zsh.enable ''
        ZSH_THEME="${toString cfg.oh-my-zsh.theme}"
        plugins=(${concatStringsSep " " allPlugins})
        source ${pkgs.oh-my-zsh}/share/oh-my-zsh/oh-my-zsh.sh
      '' + cfg.extraConfig;
    };
  }
