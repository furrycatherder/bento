{ pkgs }:

name: drvs:

pkgs.runCommand name {
  buildInputs = drvs;
} ''
  mkdir -p $out
  for input in $buildInputs; do
    cp -vR $input/. $out
  done
''
