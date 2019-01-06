{ pkgs, lib }: { name, config, ... }:

with lib;

let

  safeChars = lowerChars ++ upperChars ++ stringToCharacters "0123456789";
  cleanStr = str: concatStrings (intersectLists safeChars (stringToCharacters str));

in

  {
    options = {
      text = mkOption {
        type = with types; nullOr lines;
        default = null;
        description = "Contents of the file to be created.";
      };

      target = mkOption {
        type = types.str;
        default = "";
        description = ''
          Path to target file relative to $HOME. Currently only the $HOME
          directory is supported.
        '';
      };

      source = mkOption {
        type = with types; nullOr path;
        default = null;
        description = ''
          Path of the source file. The file name must not start with a period
          since Nix will not allow such names in the Nix store. This may refer
          to a directory.
        '';
      };
    };

    config = {
      target = mkDefault name;

      source = mkIf (config.text != null) (pkgs.writeTextFile {
        inherit (config) text;

        name = cleanStr (baseNameOf name);
      });
    };
  }
