# https://ruby-doc.org/core-2.5.0/Queue.html
# This example shows messages being produced and consumed in separate threads.

queue = Queue.new

producer = Thread.new do
  5.times do |i|
     sleep rand(i) # simulate expense
     queue << i
     puts "#{i} produced"
  end
end

consumer = Thread.new do
  5.times do |i|
     value = queue.pop
     sleep rand(i/2) # simulate expense
     puts "consumed #{value}"
  end
end

producer.join
consumer.join
