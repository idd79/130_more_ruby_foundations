# Build a times method
# A method that mimics the behavior of Integer#times, e.g.

5.times do |num|
  puts num
end

# Notice that this will print the numbers from 0 to 4 and will return 5.

def times(num)
  counter = 0
  while counter < num
    # yield(counter)
    yield(counter) if block_given?
    counter += 1
  end

  num
end

times(5) do |num|
  puts num
end

p 5.times { puts 'hello' }
p times(5) { puts 'Hello' }
p 5.times
p times(5)
