# Calculating -------------------------------------
#                slice      6.077M (± 7.0%) i/s -     30.420M in   5.034398s
#                array      6.216M (± 4.9%) i/s -     31.182M in   5.029709s

# Comparison:
#                array:  6215513.2 i/s
#                slice:  6077186.3 i/s - same-ish: difference falls within error

require 'benchmark/ips'
require 'pry'

Benchmark.ips do |x|
  x.report('slice') do
    'someraandomstring'.slice(0..4)
  end

  x.report('array') do
    'someraandomstring'[0..4]
  end

  x.compare!
end
