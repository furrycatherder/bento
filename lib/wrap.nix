{ stdenv, lib, makeWrapper }:

with lib;

prog:

let
  wrapper = config: prog // (stdenv.mkDerivation rec {
    inherit (builtins.parseDrvName prog.name) name version;

    buildInputs = [ makeWrapper ];
    buildCommand = ''
      makeWrapper ${prog}/bin/${name} $out/bin/${name} \
        ${concatStringsSep " " config.flags}
    '';

    meta = prog.meta // {
      priority = config.priority or 0;
    };
  });
in
  lib.makeOverridable wrapper
