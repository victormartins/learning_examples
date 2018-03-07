# This is thread safe because we use a queue and initialize it in the constructor
class ThreadedExecution
  def initialize(data)
    @data    = data
    @results = Queue.new
  end

  def call
    threads = []
    @data.each do |d|
      threads << Thread.new do
        results << d * 10
      end
    end

    threads.each(&:join)

    puts ''
    puts '-' * 50
    puts "#{results.size}".center(50)
    puts '-' * 50
    puts ''

    foo = []
    results.size.times do
      foo << results.pop
    end

    puts foo.inspect
    foo.sort!
    puts foo.inspect
  end

  # !!!!!!!!!!!!!!
  # This is not thread safe because each thread will try to create it, so  if they do at the same time
  # we may create more than instance of Queue and results will be lost
  # def results
  #   @results ||= Queue.new
  # end
end

data = (1..100)
test = ThreadedExecution.new(data)
test.call
