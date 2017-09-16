#!/usr/bin/env ruby
path = File.expand_path(File.dirname(__FILE__)) + '/../lib/bb2md'
require File.join(path, 'code.rb')
require File.join(path, 'list.rb')
require File.join(path, 'quote.rb')
require File.join(path, 'style.rb')
require File.join(path, 'img.rb')
require File.join(path, 'url.rb')
require File.join(path, 'version.rb')
require File.join(path, 'parser.rb')
open('posts.txt', 'r:UTF-8') do |f|
  open('new.txt', 'w:UTF-8') do |dest|
    f.each_line do |line|
      arr = eval(line.strip)
      bbid = arr[0]
      text = arr[1]
      dest.write BB2MD::Parser.new(text, bbid).parse
    end
  end
end
