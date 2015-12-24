#!/usr/bin/env ruby
# coding: utf-8

require 'sequel'
require 'csv'

def usage(s)
  print <<EOU
#{s}
usage:
$ #{$0} -i input -o outdir -t title -d db

--input, --output --title and --database are also available.

EOU
  exit(1)
end

def debug(s)
  STDERR.puts(s) if $debug
end

def make_html(dir, db, title, r, c)
  File.open(File.join(dir, "index.cgi"), "w") do |fp|
    fp.print <<EOD
#!/usr/bin/env ruby
# -*- mode: ruby -*-
require 'cgi'
require 'sequel'
cgi = CGI.new
print <<EOH
content-type: text/html

<html>
<head>
<meta charset="utf-8">
<title>index.cgi</title>
</head>
<body>
<h1>index.cgi</h1>
EOH

if ENV['REQUEST_METHOD'] =~ /GET/
# display table
ds = Sequel.sqlite("#{db}")[:tbl]
(0..#{r}).each do |row|
  (0..#{c}).each do |col|
    ds.where(row: row, col: col).each do |item|
      puts item[:data]
    end
    puts "<br>"
  end
end
else
  puts "not yet"
end

EOD
    fp.chmod(0755)
  end
end

#
# main
#

$debug = false
infile = 'input.csv'
outdir = 'out'
title = 'csv2html'
db = 'sqlite3.db'

while (arg = ARGV.shift)
  case arg
  when /\A--debug/
    $debug = true
  when /\A(-i)|(--input)/
    infile = ARGV.shift
  when /\A(-o)|(--output)/
    outdir = ARGV.shift
  when /\A(-t)|(--title)/
    title = ARGV.shift
  when /\A(-d)|(--database)/
    db = ARGV.shift
  else
    usage("unknown param: #{arg}")
  end
end

debug "params: #{infile}, #{outdir}, #{title}, #{db}"

Dir.mkdir(outdir) unless Dir.exist?(outdir)

DB = Sequel.sqlite(File.join(outdir,db))
DB.run("drop table if exists tbl;")
DB.run("create table tbl (
id integer primary key,
row int not null,
col int not null,
data varchar(255)
)")

r = 0
c = 0
CSV.foreach(infile) do |row|
  c = 0
  row.each do |data|
    DB[:tbl].insert(row: r, col: c, data: data)
    c += 1
  end
  r += 1
end

make_html(outdir, db, title, r, c)

