{ config, lib, ... }:

{
  options = with lib; {
    enable = mkEnableOption ''
        Whether to enable the vim-plug plugin manager.
    '';

    plugins = mkOption {
      default = [];
      type = with types; listOf package;
      description = ''
          A list of plugins to use.
      '';
    };
  };
}
