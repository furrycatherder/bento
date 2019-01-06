#! /usr/bin/env nix-shell
#! nix-shell -i ruby -p ruby nix-prefetch-git

require 'yaml'
require 'json'
require 'parallel'
require 'ruby-progressbar'

plugins = YAML.load (File.new "./plugins").read
total_plugins = plugins["github"].length # FIXME: merge all sublists instead

specs = Parallel.map plugins["github"], progress: "Prefetching plugins" do |plugin|
    JSON.load `nix-prefetch-git --quiet https://github.com/#{plugin} HEAD`
end

(File.new "./plugins.lock.json", "w").write JSON.pretty_generate specs

# vim: set sw=4 ts=4 et:
