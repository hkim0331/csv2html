#!/bin/sh

[ $# != 1 ] && echo usage $0 version && exit 1

echo $1 > version
sed -i.bak "s/VERSION =.*$/VERSION = '$1'/" csv2html.rb
