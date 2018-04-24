require 'benchmark/ips'
# we have an array with 13 strings and a nil and we want to know what is the most performant way to remove the nil
# Conclusion: Using compact! is faster even if we set a variable to get the result. It consumes less memory than the reject

steps = []
14.times { |i| steps << "step_name_#{i}" }

steps_hash = {}
13.times { |i| steps_hash["step_name_#{i}"] = "found_step_name_#{i}"}

Benchmark.ips do |x|
  x.report("remove nil with compact") do
    result = steps.map { |step_name| steps_hash[step_name] }
    result.compact! # this can return nil (if the array has no nils) so I cant just return it.
    result
  end

  x.report("remove nil using reject") do
    steps
      .map { |step_name| steps_hash[step_name] }
      .reject { |step| step.nil? }
  end

  x.compare!
end


# Calculating -------------------------------------
# remove nil with compact
#                         476.841k (± 8.9%) i/s -      2.373M in   5.031045s
# remove nil using reject
#                         308.476k (± 4.4%) i/s -      1.550M in   5.034553s
#
# Comparison:
# remove nil with compact:   476841.1 i/s
# remove nil using reject:   308476.0 i/s - 1.55x  slower
#


require 'memory_profiler'

def memory_profiler
  report = MemoryProfiler.report do
    yield
  end

  report.pretty_print
end

puts ''
puts '-' * 50
puts "#{:PROFILING_MEMORUY_WITH_COMPACT}".center(50)
puts '-' * 50
puts ''
memory_profiler do
  result = steps.map { |step_name| steps_hash[step_name] }
  result.compact! # this can return nil (if the array has no nils) so I cant just return it.
  result
end

# Total allocated: 312 bytes (3 objects)
# Total retained:  160 bytes (2 objects)

puts ''
puts '-' * 50
puts "#{:PROFILING_MEMORUY_WITH_REJECT}".center(50)
puts '-' * 50
puts ''
memory_profiler do
  steps
    .map { |step_name| steps_hash[step_name] }
    .reject { |step| step.nil? }
end

# Total allocated: 512 bytes (4 objects)
# Total retained:  160 bytes (2 objects)
