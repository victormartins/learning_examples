x = 0
mutex = Mutex.new

threads = 5.times.map do |thread_index|
  Thread.new do
    puts "Thread[#{thread_index}] - before x=#{x}"
    mutex.synchronize { x += 1 }
    sleep rand(0.1..0.3)
    puts "Thread[#{thread_index}] - after x=#{x}"
  end
end

threads.each(&:join)
puts "\nTotal: #{x}"

#  !!!!!!!!!!!
#  We still have some weird math going on, but the result is fixed
#
# Thread[0] - before x=0
# Thread[4] - before x=0
# Thread[2] - before x=0
# Thread[1] - before x=0
# Thread[3] - before x=0
# Thread[1] - after x=5
# Thread[4] - after x=5
# Thread[3] - after x=5
# Thread[2] - after x=5
# Thread[0] - after x=5
#
# Total: 5  << Fixed the result
