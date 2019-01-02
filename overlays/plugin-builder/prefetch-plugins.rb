#! /usr/bin/env ruby

require 'yaml'
require 'json'
require 'parallel'
require 'progressbar'

plugins = YAML.load (File.new "./plugins").read
total_plugins = plugins["github"].length # FIXME: merge all sublists instead

specs = Parallel.map plugins["github"], progress: "Prefetching plugins" do |plugin|
    JSON.load `nix-prefetch-git --quiet https://github.com/#{plugin} HEAD`
end

(File.new "./plugins.lock", "w").write specs.to_json

# vim: set sw=4 ts=4 et:
