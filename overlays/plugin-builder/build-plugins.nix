{ lib, recurseIntoAttrs, fetchgit }:

pluginSpecs:

with builtins;

let

  cleanStr = replaceStrings [ "." ] [ "-" ];

  fetchPlugin = plugin: rec {
    name = cleanStr (baseNameOf plugin.url);
    value = fetchgit {
      inherit name;
      inherit (plugin) url rev sha256;
    };
  };

  plugins = map fetchPlugin (lib.importJSON pluginSpecs);

in

  recurseIntoAttrs (listToAttrs plugins)
