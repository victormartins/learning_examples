# This script measures three ways of concatenating a 10Mb string 3 times.
# The more times we copy the string to do the operation, the bigger the
# memory foot print and the slower we get.


require "json"
require "benchmark"

# Code from https://pragprog.com/book/adrpo/ruby-performance-optimization
def measure(&block)
  no_gc = (ARGV[0] == "--no-gc")

  if no_gc
    GC.disable
  else
    # collect memory allocated during library loading
    # and our own code before the measurement
    GC.start
  end

  memory_before = `ps -o rss= -p #{Process.pid}`.to_i / 1024
  gc_stat_before = GC.stat

  time = Benchmark.realtime do
    yield
  end

  # puts ObjectSpace.count_objects
  GC.start unless no_gc
  # puts ObjectSpace.count_objects

  gc_stat_after = GC.stat
  memory_after = `ps -o rss= -p #{Process.pid}`.to_i / 1024

  puts({
    RUBY_VERSION => {
      gc: no_gc ? 'disabled' : 'enabled',
      time: time.round(2),
      gc_count: gc_stat_after[:count] - gc_stat_before[:count],
      memory_used: "%d MB" % (memory_after - memory_before)
    }
  }.to_json)
end

def ten_mb_string
  @ten_mb_string ||= "S" * 1024 * 1024 * 10
end

# Consumes 71Mb Memory
r1 = ''
measure do
  3.times do
    r1 += ten_mb_string # copies the string to a new object before adding it
  end
end

# Consumes 30Mb Memory
r2 = ''
measure do
  r2 = ten_mb_string + ten_mb_string + ten_mb_string # 3 copies of the string
end

# Consumes 10Mb Memory
r3 = ''
measure do
  3.times do |i|
    r3 << ten_mb_string
  end
end

puts r1.length
puts r2.length
puts r3.length
