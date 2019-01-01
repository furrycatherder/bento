final: previous:

with final;

{
  zshPlugins = recurseIntoAttrs (buildPlugins (lib.importJSON ./plugins.lock));
}
