self: super:

{

  zshPlugins = super.recurseIntoAttrs (super.callPackage ./plugins {});

}
