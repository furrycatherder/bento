let
  # TODO: support xdg-user-dirs
  configuration = builtins.getEnv "HOME" + "/.config/bento";

in map import [
  configuration

  # user environment
  ./home.nix

  # programs
  ./programs/command-not-found
  ./programs/direnv
  ./programs/neomutt
  ./programs/neovim
  ./programs/zsh
]
