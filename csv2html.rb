#!/usr/bin/env ruby
# coding: utf-8

VERSION = '0.3'

require 'sequel'
require 'csv'

def usage(s)
  print <<EOU
#{s}
usage:
$ #{$0} -i input.csv -o dir -t 'title' -d db

--input, --outdir --title and --database are also available.

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
ds = Sequel.sqlite("#{db}")[:tbl]
th = Sequel.sqlite("#{db}")[:th]

if ENV['REQUEST_METHOD'] =~ /GET/
  print <<EOH
content-type: text/html

<html>
<head>
<meta charset="utf-8">
<title>#{title}</title>
<style>
table {border-collapse: collapse;}
th, td {border: 0px;}
form {margin: 0px;}
input {width: 8em;}
</style>
</head>
<body>
<h1>#{title}</h1>
<p>目的のコラムを編集後、リターン（エンター）キーで確定します。</p>
EOH

  # display table
  puts "<table>"
  n = 0
  (0...#{r}).each do |row|
    puts "<tr><td>" + n.to_s + "</td>"
    n += 1
    (0..#{c}).each do |col|
      ds.where(row: row, col: col).each do |item|
        puts "<td><form method='post'>"
        puts "<input type='hidden' name='row' value='" + row.to_s + "'>"
        puts "<input type='hidden' name='col' value='" + col.to_s + "'>"
        puts "<input name='data' value='" + item[:data] + "'>"
        puts "</form></td>"
      end
    end
    puts "</tr>"
  end
  puts "</table>"
  puts "<hr>programmed by hkimura, #{VERSION}, "
  puts "<a href='https://github.com/hkim0331/csv2html.git'>"
  puts "https://github.com/hkim0331/csv2html.git</a>"
else
  ds.where(row: cgi['row'], col: cgi['col']).update(data: cgi['data'])

  print cgi.header({
  "status" => "REDIRECT",
  "location" => "index.cgi"})
end

EOD
    fp.chmod(0755)
  end
end

#
# main starts here.
#

$debug = false
infile = 'sample.csv'
outdir = 'public'
title = 'csv2html sample'
db = 'sqlite3.db'

while (arg = ARGV.shift)
  case arg
  when /\A--debug/
    $debug = true
  when /\A(--input)|(-i)/
    infile = ARGV.shift
  when /\A(--outdir)|(-o)/
    outdir = ARGV.shift
  when /\A(--title)|(-t)/
    title = ARGV.shift
  when /\A(--database)|(-d)/
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

r = 1
c = 0
CSV.foreach(infile) do |row|
  c = 0
  row.each do |data|
    data = '' if data.nil?
    data = '' if data =~ /\A　+\Z/
    raise "data is nil" if data.nil?
    DB[:tbl].insert(row: r, col: c, data: data)
    c += 1
  end
  r += 1
end

(0...c).each do |c|
  DB[:tbl].insert(row: 0, col:c, data: c)
end

make_html(outdir, db, title, r, c)

