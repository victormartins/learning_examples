require "benchmark"
require 'memory_profiler'

# WITH GC ON
# consumes_4Gb_memory: 5.29
# consumes_3Gb_memory: 2.23
# consumes_2Gb_memory: 2.07
# consumes_1Gb_memory: 1.1
#
# GC.disable
# WITH GC OFF
# consumes_4Gb_memory: 2.62
# consumes_3Gb_memory: 1.84
# consumes_2Gb_memory: 1.86
# consumes_1Gb_memory: 1.26
#
# We can see it is Garbage Collector that consumes most of the processing time
# which shows that if we have less memory wasted we will be faster

# Test class to encapsulate test logic
class Test
  # In this example we start by creating an array with 1Gb memory footprint
  # We can measure its speed in different ruby versions like so:
  #
  # rbenv shell 2.3.0 && memory_optimization.rb
  # rbenv shell 2.5.0 && memory_optimization.rb
  #
  # We can also compare how long it takes to run with or without garbage collector
  # so that we can measure how long it take from the program to clean its memory.
  # GC is the slowest part of Ruby, so the bigger the memory footprint the slower
  # it gets. To do this, simply run the program by uncommenting line 3 "GC.disable"
  # We should see a big differece. example: With GC ON: 1.36, With GC OFF: 2.04 (66% increase!)
  # We can use the memory_profiler method to see what memory was used.
  def speed_profiler
    time = Benchmark.realtime do
      consumes_4Gb_memory(one_gb_array)
    end

    puts "consumes_4Gb_memory: #{time.round(2)}"

    time = Benchmark.realtime do
      consumes_3Gb_memory(one_gb_array)
    end

    puts "consumes_3Gb_memory: #{time.round(2)}"

    time = Benchmark.realtime do
      consumes_2Gb_memory(one_gb_array)
    end

    puts "consumes_2Gb_memory: #{time.round(2)}"

    time = Benchmark.realtime do
      consumes_1Gb_memory(one_gb_array)
    end

    puts "consumes_1Gb_memory: #{time.round(2)}"
  end

  def memory_profiler
    report = MemoryProfiler.report do
      yield
    end

    # report.pretty_print(to_file: "memory_profiler_#{timestamp}.txt")
    report.pretty_print
  end

  def one_gb_array
    @one_gb_array ||= begin
      num_rows = 100_000
      num_cols = 10

      data = Array.new(num_rows) do
        Array.new(num_cols) do
          "x" * 1000
        end
      end
    end
  end

  # This method will use 2Gb of memory since it firsts puts the result of the map in memory
  # and then uses the join to create a new version with the newline char.
  # Bellow is the report of the memory_profiler that shows that we duplicate 1Gb of memory
  # when we do the join.
  #
  # Total allocated: 2103689148 bytes (2300004 objects) (2Gb) ! 1Gb Wasted!
  # Total retained:  1053799039 bytes (1100001 objects) (1Gb)
  def consumes_2Gb_memory(one_gb_data)
    one_gb_data
      .map { |row| row.join(",") }
      .join("\n")
  end

  # Total allocated: 3113579097 bytes (2500003 objects) (3Gb) ! 1Gb Wasted!
  # Total retained:  1053799039 bytes (1100001 objects) (1Gb)
  def consumes_3Gb_memory(one_gb_data)
    one_gb_data
      .map { |row| row.join(",") }
      .map { |row| row + "\n" }
  end

  # Total allocated: 4114479099 bytes (2500003 objects) (4Gb) ! 3Gb Wasted!
  # Total retained:  1053799039 bytes (1100001 objects) (1Gb)
  def consumes_4Gb_memory(one_gb_data)
    one_gb_data
      .map { |row| row.join(",") }
      .map { |row| "#{row}\n" }
  end

  # This optimization doesn’t store any intermediate results. For
  # that I’ll explicitly loop over rows with a nested loop over columns and store
  # results as I runs.
  #
  # Total allocated: 1133799039 bytes (3100001 objects) (1.13Gb) Just 133Mb extra
  # Total retained:  1053799039 bytes (1100001 objects) (1Gb)
  def consumes_1Gb_memory(one_gb_data)
    num_rows = 100_000
    num_cols = 10
    csv = ''
    num_rows.times do |i|
      num_cols.times do |j|
        csv << one_gb_data[i][j]
        csv << "," unless j == num_cols - 1
      end
      csv << "\n" unless i == num_rows - 1
    end
  end


  def timestamp
    Time.now.strftime('%Y%m%d_%H%M%S')
  end
end

t = Test.new
t.speed_profiler
# t.memory_profiler { t.consumes_2Gb_memory(t.one_gb_array) }
# t.memory_profiler { t.consumes_3Gb_memory(t.one_gb_array) }
# t.memory_profiler { t.consumes_4Gb_memory(t.one_gb_array) }
# t.memory_profiler { t.consumes_1Gb_memory(t.one_gb_array) }
