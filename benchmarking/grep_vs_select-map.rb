# In this example we have an array with 100_000 file names and
# we want to select all files with the .rb extesion and remove
# the extension.
# We compare how fast it is using grep in single operation
# or by selecting first and map after.
#
# They have pretty much the same speed
#
# Comparison:
#                grep:       11.4 i/s
#      select and map:       11.1 i/s - same-ish: difference falls within error



require 'benchmark/ips'

ficheiros = (1..100_000).each.with_object([]) do |i, result|
  ext = ["rb", "txt", "jpg", "raw", "foo" ].sample
  result << "ficheiro_#{i}.#{ext}"
end

Benchmark.ips do |x|
  x.report("grep") do
    ficheiros.grep(/(.*)\.rb/){$1}
  end

  x.report("select and map") do
    ficheiros
      .select{ |x| x =~ /\.rb/ }
      .map{ |x| x[0..-4] }
  end

  x.compare!
end
