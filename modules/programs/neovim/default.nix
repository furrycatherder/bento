{ config, pkgs, lib, ... }:

let

  cfg = config.programs.neovim;

  vim-plug = import ./vim-plug.nix;

in

  {
    options = with lib; {
      programs.neovim = {
        enable = mkEnableOption ''
          Whether to enable neovim, the future of vim.
        '';

        extraConfig = mkOption {
          type = types.lines;
          default = "";
          description = ''
            Extra configuration lines to put in init.vim.
          '';
        };

        vim-plug = mkOption {
          type = types.submodule vim-plug;
          default = {};
          description = ''
            Configuration options for vim-plug.
          '';
        };
      };
    };

    config = with lib; mkIf cfg.enable {
      home.files.".config/nvim/init.vim".text = optionalString cfg.vim-plug.enable (''
        source ${pkgs.neovimPlugins.vim-plug}/plug.vim
        call plug#begin('/dev/null')
      '' + concatMapStrings (plugin: ''
        Plug '${plugin}'
      '') cfg.vim-plug.plugins + ''
        call plug#end()
      '') + cfg.extraConfig;
    };
  }
