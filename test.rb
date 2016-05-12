$last_action = Time.new # who needs thread safety
$prev_last_action = $last_action
$recorded = true

seconds_cutoff = 10

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

def get_file(name)
	File.join(__dir__, name)
end

loop do
	sleep 1
	if !$recorded && Time.new - $last_action > seconds_cutoff
		$recorded = true
		str = $last_action.strftime('%H:%M:%S') 
		puts str
		File.open(get_file('log.txt'), 'a') do |file|
			file.puts str + '\n'
		end
	end
end
