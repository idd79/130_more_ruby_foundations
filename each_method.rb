# Build a 'each' method

# Keep in mind that 'each' returns the object, say tha array, itself.

def each(array)
  idx = 0
  while idx < array.size
    yield(array[idx]) if block_given?
    idx += 1
  end

  array
end

p [1, 2, 3].each { |num| puts num }
p each([1, 2, 3]) { |num| puts num }

p each([1, 2, 3, 4, 5]) {|num| puts "do nothing"}.select{ |num| num.odd? }
# => [1, 3, 5]