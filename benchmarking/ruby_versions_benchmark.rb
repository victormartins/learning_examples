require 'benchmark_driver'

Benchmark.driver do |x|
  x.prelude %{
    def script
      i = 0
      while i < 1000_000
        i += 1
      end
      i
    end
  }
  x.report 'while', %{ script }
  x.loop_count 2000

  x.verbose
  x.rbenv(
    '2.0.0::2.0.0-p0',
    '2.3.0',
    '2.5.0',
  )
end



# 2.0.0: ruby 2.0.0p0 (2013-02-24 revision 39474) [x86_64-darwin17.4.0]
# 2.3.0: ruby 2.3.0p0 (2015-12-25 revision 53290) [x86_64-darwin16]
# 2.5.0: ruby 2.5.0p0 (2017-12-25 revision 61468) [x86_64-darwin17]
# Calculating -------------------------------------
#                           2.0.0       2.3.0       2.5.0
#                while     58.754      59.356      59.242 i/s -      2.000k times in 34.040247s 33.695179s 33.759657s
#
# Comparison:
#                             while
#                2.3.0:        59.4 i/s
#                2.5.0:        59.2 i/s - 1.00x  slower
#                2.0.0:        58.8 i/s - 1.01x  slower
