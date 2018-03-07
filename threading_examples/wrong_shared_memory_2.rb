x = 0

threads = 5.times.map do |thread_index|
  Thread.new do
    puts "Thread[#{thread_index}] - before x=#{x}"
    x += 1
    sleep rand(0.1..0.3)
    puts "Thread[#{thread_index}] - after x=#{x}"
  end
end

threads.each(&:join)
puts "\nTotal: #{x}"

# Thread[3] - before x=0
# Thread[1] - before x=1
# Thread[2] - before x=2
# Thread[0] - before x=3
# Thread[4] - before x=4
# Thread[3] - after x=5         # ! 0 + 1 = 5
# Thread[4] - after x=5         # OK 4 + 1 = 5
# Thread[0] - after x=5         # ! 3 + 1 = 5
# Thread[2] - after x=5         # ! 2 + 1 = 5
# Thread[1] - after x=5         # ! 1 + 1 = 5
#
# Total: 5 << With ruby MRI the GLobal Interpreter Lock saves the day and keeps the total is always correct
# because += will be atomic
# Used ruby 2.4.1 at this current time


# !!!!!!!!!!!!!!!
# However with jRuby and Rubinius that offer true parallelization the total will be corrupted!
# Used jruby 9.1.12.0 (2.3.3) at this current time

# Thread[4] - before x=0
# Thread[0] - before x=0
# Thread[1] - before x=0
# Thread[3] - before x=0
# Thread[2] - before x=0
# Thread[0] - after x=1
# Thread[1] - after x=1
# Thread[3] - after x=1
# Thread[4] - after x=1
# Thread[2] - after x=1
#
# Total: 1                !!!!!!!!!!!!!!!!!!!!
