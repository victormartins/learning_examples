# Shared memory accross threads is dangerous!

# This class represents an ecommerce order
Order = Struct.new(:amount, :status) do
  def pending?
    status == 'pending'
  end

  def collect_payment
    puts "Collecting payment..."
    self.status = 'paid'
  end
end

# Create a pending order for $100
order = Order.new(100.00, 'pending')
# We can use a mutex to create a locking mechanism on the order variable, so if two threads compete, one will wait
# for the lock to be released.
mutex = Mutex.new

# Ask 50 threads to check the status, and collect payment if it's 'pending'
50.times.map do
  Thread.new do
    puts 'Checking'
    mutex.synchronize do
      if order.pending?
        order.collect_payment
      end
    end
  end
end.each(&:join)
