final: previous:

with final;

{
  neovimPlugins = recurseIntoAttrs (buildPlugins (lib.importJSON ./plugins.lock));
}
