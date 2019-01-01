#! /usr/bin/env ruby

require 'yaml'
require 'json'
require 'progressbar'

plugins = YAML.load (File.new "./plugins").read
total_plugins = plugins["github"].length # FIXME: merge all sublists instead
progressbar = ProgressBar.create :title => "prefetching plugins",
    :total => total_plugins, :length => 80, :format => "%c/%C |%B| %t"
specs = []

plugins["github"].each do |plugin|
    specs << (JSON.load `nix-prefetch-git --quiet https://github.com/#{plugin} HEAD`)
    progressbar.increment
end

(File.new "./plugins.lock", "w").write specs.to_json

# vim: set sw=4 ts=4 et:
