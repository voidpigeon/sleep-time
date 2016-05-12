def listen(path, &block)
	File.open(path) do |file|
		file.each_char(&block)
	end
end

Thread.new do
	listen('/dev/input/mouse0') do
		puts 'mouse'
	end
end

listen('/dev/input/event0') do
	puts 'keyboard'
end
