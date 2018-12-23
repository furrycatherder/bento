{ lib, fetchgit }:

with builtins;

let
  pluginSpecs = map lib.importJSON [
    ./nix-zsh-completions.json
    ./zsh-nix-shell.json
    ./zsh-completions.json
    ./zsh-autosuggestions.json
    ./zsh-syntax-highlighting.json
  ];

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
