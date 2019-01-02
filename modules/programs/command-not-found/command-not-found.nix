{ config, lib, perl, perlPackages, substituteAll, dbPath }:

let

  mkPerlIFlag = path: "-I ${path}/lib/perl5/site_perl";

  dependencies = with perlPackages; [
    DBI
    DBDSQLite
    StringShellQuote
  ];

in

  substituteAll {
    inherit dbPath;
    inherit perl;

    name = "command-not-found";
    dir = "bin";
    src = ./command-not-found.pl;
    isExecutable = true;
    perlFlags = lib.concatMapStringsSep " " mkPerlIFlag dependencies;
  }
