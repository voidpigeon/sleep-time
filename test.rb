$last_action = Time.new

def listen(path)
	Thread.new do
		File.open(path) do |file|
			file.each_char do
				$last_action = Time.new
			end
		end
	end
end

listen('/dev/input/mouse0')

listen('/dev/input/event0')

loop do
	sleep 1
	puts $last_action.strftime("%H:%M:%S")
end
