#!/usr/bin/env ruby

if ENV['USER'] != 'root'
	abort 'must run as root'
end

def get_file(name)
	File.join(__dir__, name)
end

log_file = get_file('log.txt')

if !File.file?(log_file)
	File.write(log_file, '')
end

def parse_config(str)
	params = [:seconds_cutoff, :time_format]
	result = {}
	for param in params
		regex = /^#{param.to_s}=(.*)$/
		if str[regex]
			result[param] = $1
		end
	end
	result
end

config = parse_config(File.read(get_file("config.conf")))

$last_action = Time.new # who needs thread safety
$recorded = false

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

listen('/dev/input/mice') # TODO: add option to disable mouse
listen('/dev/input/event0') # TODO: check how cross-platform this is

loop do
	sleep 1
	if !$recorded && Time.new - $last_action > eval(config[:seconds_cutoff])
		$recorded = true
		str = $last_action.strftime(config[:time_format])
		File.open(log_file, 'a') do |file|
			file.puts str
		end
	end
end
