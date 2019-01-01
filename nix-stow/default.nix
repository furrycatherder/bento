{ pkgs, cwd }:

pkgs.stdenv.mkDerivation {
  name = "nix-stow";

  # Dependencies to be injected into the shell script.
  inherit (pkgs) bash;
  inherit cwd;

  buildCommand = ''
    install -v -D -m755 ${./nix-stow} $out/bin/nix-stow

    substituteAllInPlace $out/bin/nix-stow
  '';

  meta = with pkgs.stdenv.lib; {
    description = "A framework for building declarative overlayfs";
    maintainers = [ maintainers.ma9e ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
