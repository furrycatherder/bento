{ configuration }:

map import [
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
