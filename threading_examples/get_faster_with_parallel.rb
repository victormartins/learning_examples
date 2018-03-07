started = Time.now
5.times.map { sleep 1 }
ended = Time.now

threaded_started = Time.now
threads = 5.times.map do
  Thread.new { sleep 1 }
end
threads.each(&:join)
threaded_ended = Time.now

puts "Without Threads: #{ended - started}"
puts "With Threads #{threaded_ended - threaded_started}"

# We can see that if we parallelize something that takes 1 second to complete
# we can do it 5 times in one second.
# Without Threads: 5.011301
# With Threads 1.001329
