#!/usr/bin/env ruby

require 'csv'

prev = nil

CSV::Writer.generate(STDOUT) { |out|
  CSV::Reader.parse(STDIN).each { |r|
    if (r[0] == nil)
      r[0] = prev
    else
      prev = r[0]
    end
    printf '%s', ARGV[0]
    out << r
  }
}
