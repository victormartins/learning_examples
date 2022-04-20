# Saw this interesting strategy to setup callbacks in Datadog gem
# https://github.com/DataDog/dd-trace-rb/blob/017624521d2f73643be30a5ee41e48a226a4dea1/lib/datadog/tracing/contrib/http/instrumentation.rb#L21
# https://github.com/DataDog/dd-trace-rb/blob/017624521d2f73643be30a5ee41e48a226a4dea1/lib/datadog/tracing/contrib/http/instrumentation.rb#L65-L67

class SayWithCallback
  def self.before_callback(&callback_block)
    if callback_block
      @before_callback = callback_block
    else
      @before_callback ||= nil
    end
  end

  def self.after_callback(&callback_block)
    if callback_block
      @after_callback = callback_block
    else
      @after_callback ||= nil
    end
  end

  def call(msg)
     SayWithCallback.before_callback.call(msg) unless SayWithCallback.before_callback.nil?

    puts msg

    SayWithCallback.after_callback.call(msg) unless SayWithCallback.after_callback.nil?
  end
end


puts 'Running without callbacks:'
puts '-' * 25
SayWithCallback.new.call('Hello World')
# => Hello World

puts

puts 'Running with callbacks:'
puts '-' * 25
SayWithCallback.before_callback { |msg| puts "Before saying #{msg}" }
SayWithCallback.after_callback { |msg| puts "After saying #{msg}" }
SayWithCallback.new.call('Hello World')
# => Before saying Hello World
# => Hello World
# => After saying Hello World
