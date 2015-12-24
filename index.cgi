#!/usr/bin/env ruby
# -*- mode: ruby -*-
require 'cgi'

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
  
else

end
