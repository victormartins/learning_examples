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

# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Create a pending order for $100
# This is dangerous because this variable will be shared accross threads
order = Order.new(100.00, 'pending')


# Ask 50 threads to check the status, and collect payment if it's 'pending'
50.times.map do
  Thread.new do
    puts 'Checking'
    if order.pending?
      order.collect_payment
    end
  end
end.each(&:join)


# We can check a double payment bellow!
#
# Checking
# Collecting payment...Checking
# Checking
# Checking
# Checking
# Collecting payment...
# Checking
# Checking
# Checking
# Checking
# Checking
# CheckingChecking
# Checking
# Checking
# Checking
# Checking
# Checking
# Checking
# Checking
# Checking
# Checking
# Checking
# CheckingChecking
# Checking
# Checking
# Checking
# Checking
# Collecting payment...
# Checking
# Checking
# Checking
# Checking
# Checking
# Checking
# Checking
# Checking
# Checking
# Checking
# Checking
# Checking
# Collecting payment...
# Checking
# Checking
# Checking
# Checking
# Checking
# Collecting payment...
# Checking
# Checking
# Checking
# Checking
# Checking
