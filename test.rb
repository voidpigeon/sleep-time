#!/usr/bin/env ruby

def parse_config(str)
	params = [:seconds_cutoff]
	result = {}
	for param in params
		regex = /^\s*#{param.to_s}\s*=\s*(\d+)\s*$/
		if str[regex]
			result[param] = $1.to_i
		end
	end
	result
end

def get_file(name)
	File.join(__dir__, name)
end

config = parse_config(File.read(get_file("config.conf")))

$last_action = Time.new # who needs thread safety
$prev_last_action = $last_action
$recorded = true

def listen(path)
	Thread.new do
		File.open(path) do |file|
			file.each_char do
				$last_action = Time.new
				$recorded = false
			end
		end
	end
end

listen('/dev/input/mouse0')
listen('/dev/input/event0')

loop do
	sleep 1
	if !$recorded && Time.new - $last_action > config[:seconds_cutoff]
		$recorded = true
		str = $last_action.strftime('%H:%M:%S') 
		puts str
		File.open(get_file('log.txt'), 'a') do |file|
			file.puts str
		end
	end
end
