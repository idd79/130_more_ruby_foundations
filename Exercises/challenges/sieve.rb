# sieve.rb

class Sieve
  def initialize(num)
    @num = num
    @original = [2] + (3..@num).to_a.select { |val| val.odd? }
  end

  def primes
    next_prime = 3
    while next_prime < @original.last
      series = (next_prime**2).step(@num, next_prime).map { |e| e }
      @original -= series
      next_prime = @original[@original.index(next_prime) + 1]
    end

    @original
  end
end

# Solution from another student in launchshool, which runs quit fast:

# class Sieve
#   def initialize(limit)
#     @limit = limit
#     @nums = (2..limit).map { |n| [n, true] }.to_h
#   end

#   def primes
#     @nums.each { |num, prime| mark_multiples(num) if prime }.compact.keys
#   end

#   private

#   def mark_multiples(num)
#     (num * 2).step(@limit, num).each { |multiple| @nums[multiple] = nil }
#   end
# end

# test = Sieve.new(100000)
# p test.primes

require 'prime'

def benchmark
  start_time = Time.now
  yield
  puts "Seconds: #{Time.now - start_time}"
end

benchmark { p Sieve.new(100_000).primes == Prime.entries(100_000) }
# benchmark { p Sieve.new(100_000).primes }