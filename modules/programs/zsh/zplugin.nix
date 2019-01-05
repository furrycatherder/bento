{ config, lib, ... }:

{
  options = with lib; {
    enable = mkEnableOption "zplugin, a plugin manager for zsh";

    plugins = mkOption {
      default = [];
      type = with types; listOf package;
      description = ''
        A list of plugins to use.
      '';
    };
  };
}
