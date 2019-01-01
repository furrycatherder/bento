{ lib, fetchgit }:

pluginSpecs:

with builtins;

let
  fetchPlugin = plugin: rec {
    name = baseNameOf plugin.url;
    value = fetchgit {
      inherit name;
      inherit (plugin) url rev sha256;
    };
  };

  plugins = map fetchPlugin pluginSpecs;
in
  listToAttrs plugins
