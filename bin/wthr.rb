#!/usr/bin/env ruby
require 'wthr'

if (!File.exists?(Wthr::CLI::CONFIG_FILE) && (ARGV[0] != 'key'))
  abort "Please set your developer key. Run 'wthr help' for more information."
end

Wthr::CLI.start