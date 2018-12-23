{ pkgs, lib }: { config, ... }:

let

  mkLinkFarmEntry = drv: {
    name = (builtins.parseDrvName drv.name).name;
    path = drv;
  };

  pluginsDir = pkgs.linkFarm "omz-custom-plugins" (
    map mkLinkFarmEntry config.customPlugins);

  themesDir = pkgs.linkFarm "omz-custom-themes" (
    map mkLinkFarmEntry config.customThemes);

in

  {
    options = with lib; {
      enable = mkEnableOption ''
        Whether to enable the Oh My Zsh configuration framework.
      '';

      plugins = mkOption {
        default = [];
        type = with types; listOf str;
        description = ''
          A list of builtin Oh My Zsh plugins to use.
        '';
      };

      theme = mkOption {
        default = null;
        type = with types; nullOr str;
        description = ''
          The zsh prompt theme to use.
        '';
      };

      customPlugins = mkOption {
        default = [];
        type = with types; listOf package;
        description = ''
          A list of custom plugins to link into ZSH_CUSTOM/plugins.
        '';
      };

      customThemes = mkOption {
        default = [];
        type = with types; listOf package;
        description = ''
          A list of custom plugins to link into ZSH_CUSTOM/plugins.
        '';
      };

      custom = mkOption {
        default = null;
        type = with types; nullOr path;
        description = ''
          A path to use as the value of ZSH_CUSTOM.
        '';
      }; 
    };

    config = with lib; {
      custom = pkgs.linkFarm "omz-custom" [
        { name = "plugins"; path = pluginsDir; }
        { name = "themes"; path = themesDir; }
      ];
    };
  }
