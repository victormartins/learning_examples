# Calculating -------------------------------------
#                 eval     36.867k (± 5.7%) i/s -    186.440k in   5.075067s
#                 send    736.645k (± 7.4%) i/s -      3.692M in   5.044326s
#          public_send    728.383k (± 4.9%) i/s -      3.687M in   5.075179s

# Comparison:
#                 send:   736645.4 i/s
#          public_send:   728382.7 i/s - same-ish: difference falls within error
#                 eval:    36866.7 i/s - 19.98x  slower


require 'benchmark/ips'
require 'pry'

Benchmark.ips do |x|

  class Entity
    attr_reader :foo, :bar, :baz, :xpto

    ATTRIBUTES_TO_SET = %w[foo bar baz xpto]

    def initialize
      @foo = :foo
      @bar = :bar
      @baz = :baz
      @xpto = :xpto
    end

    def with_eval
      entity = {}

      ATTRIBUTES_TO_SET.each do |attr|
        entity[attr] = eval(attr)
      end

      entity
    end

    def with_send
      entity = {}

      ATTRIBUTES_TO_SET.each do |attr|
        entity[attr] = send(attr)
      end

      entity
    end

    def with_public_send
      entity = {}

      ATTRIBUTES_TO_SET.each do |attr|
        entity[attr] = public_send(attr)
      end

      entity
    end
  end

  x.report('eval') do
    Entity.new.with_eval
  end

  x.report('send') do
    Entity.new.with_send
  end

  x.report('public_send') do
    Entity.new.with_send
  end

  x.compare!
end
