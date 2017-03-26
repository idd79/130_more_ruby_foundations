# Write a select method that mirrors the behavior of Array#select. Note that the
# Array#select method takes a block, then yields each element to the block. If
# the block evaluates to true, the current element will be included in the
# returned array. If the block evaluates to false, the current element will not
# be included in the returned array.

def select(array)
  result = []
  array.each { |elm| result << elm if yield(elm) }
  result
end

array = [1, 2, 3, 4, 5]

p select(array) { |num| num.odd? }      # => [1, 3, 5]
p select(array) { |num| puts num }      # => [], because "puts num" returns nil and evaluates to false
p select(array) { |num| num + 1 }       # => [1, 2, 3, 4, 5], because "num + 1" evaluates to true
