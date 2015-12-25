#!/usr/bin/env ruby

while (line = STDIN.gets) do
	if line =~ /pid=(\d+)/
		File.open("pid","w") do |fp|
			fp.puts $1
		end
		exit(0)
	end
end

