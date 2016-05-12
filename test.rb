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

loop do
	sleep 1
	if !$recorded && Time.new - $last_action > seconds_cutoff
		$recorded = true
		puts $last_action.strftime('%H:%M:%S')
	end
end
