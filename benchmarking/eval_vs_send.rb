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
  end

  x.report('eval') do
    Entity.new.with_eval
  end

  x.report('send') do
    Entity.new.with_send
  end

  x.compare!
end
