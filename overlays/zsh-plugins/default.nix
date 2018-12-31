final: previous:

with final;

{
  zshPlugins = recurseIntoAttrs (callPackage ./plugins {});
}
