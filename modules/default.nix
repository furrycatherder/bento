{ pkgs, lib, configuration, ... }:

let

  pkgsModule = {
    config._module.args.pkgs = lib.mkDefault pkgs;
  };

in

  map import [
    configuration

    # user environment
    ./home.nix

    # programs
    ./programs/command-not-found
    ./programs/direnv
    ./programs/neomutt
    ./programs/zsh
  ] ++ [
    pkgsModule
  ]
