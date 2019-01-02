{ config, pkgs, lib, ... }:

let

  cfg = config.programs.command-not-found;

  command-not-found = pkgs.callPackage ./command-not-found.nix {
    inherit (cfg) dbPath;
  };

in

  {
    options = with lib; {
      programs.command-not-found = {
        enable = mkEnableOption ''
          Whether to enable command-not-found, a "command not found" handler.
        '';

        dbPath = mkOption {
          default = <nixos/programs.sqlite>;
          type = types.path;
          description = ''
            The path to command-not-found's program database.
          '';
        };
      };
    };

    config = with lib; mkIf cfg.enable {
      home.files.".zshrc".text = mkIf config.programs.zsh.enable ''
        # This function is called whenever a command is not found.
        command_not_found_handler() {
          local p=${command-not-found}/bin/command-not-found
          if [ -x $p -a -f ${cfg.dbPath} ]; then
            # Run the helper program.
            $p "$@"

            # Retry the command if we just installed it.
            if [ $? = 126 ]; then
              "$@"
            fi
          else
            # Indicate than there was an error so ZSH falls back to its default handler
            echo "$1: command not found" >&2
            return 127
          fi
        }
      '';
    };
  }
