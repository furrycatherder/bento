{ name, config, lib, ... }:

{
  options = with lib; {
    username = mkOption {
      type = with types; nullOr str;
      default = null;
      description = "A username.";
    };

    password = mkOption {
      type = with types; nullOr str;
      default = null;
      description = "A password.";
    };

    key = mkOption {
      type = with types; nullOr str;
      default = null;
      description = "An API key.";
    };
  };
}
