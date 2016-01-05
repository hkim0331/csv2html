#!/usr/bin/env ruby
# coding: utf-8
#
# 2015-12-25, 自分のプロセス番号を書き出したい。

require 'webrick'
include WEBrick

def usage()
  print <<EOF
usage:
  server [--port port] [--root documentroot]
EOF
  exit(1)
end

port = 2000
root = "public"
while (arg = ARGV.shift)
  case arg
  when /--port/
    port=ARGV.shift.to_i
  when /--root/i
    root=ARGV.shift
  else
    usage()
  end
end
s = HTTPServer.new(
	:Port		=> port,
	:DocumentRoot 	=> File.join(Dir.pwd, root)
)
trap("INT") {s.shutdown}
s.start
puts Process.pid