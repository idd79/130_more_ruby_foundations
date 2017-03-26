# Build your own reduce/inject method

def reduce(array, ini_val = 0)
  result = ini_val
  array.each { |elm| result = yield(result, elm) }
  result
end

array = [1, 2, 3, 4, 5]

p reduce(array) { |acc, num| acc + num }                    # => 15
p reduce(array, 10) { |acc, num| acc + num }                # => 25
p reduce(array) { |acc, num| acc + num if num.odd? }        # => NoMethodError: undefined method `+' for nil:NilClass