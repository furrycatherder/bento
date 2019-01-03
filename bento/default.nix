{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "bento";

  # Dependencies to be injected into the shell script.
  inherit (pkgs) bash;

  buildCommand = ''
    install -v -D -m755 ${./bento} $out/bin/bento

    substituteAllInPlace $out/bin/bento
  '';

  meta = with pkgs.stdenv.lib; {
    description = "A framework for building declarative overlayfs";
    maintainers = [ maintainers.ma9e ];
    platforms = platforms.unix;
    license = licenses.mit;
  };
}
