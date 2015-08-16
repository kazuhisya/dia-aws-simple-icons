#!/usr/bin/ruby

require "rexml/document"

xml = REXML::Document.new File.new(ARGV[0])
doc = xml.root

doc.elements["//g[@id='nyt_x5F_exporter_x5F_info']"].remove
puts doc
