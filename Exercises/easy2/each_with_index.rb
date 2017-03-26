# Implement each_with_index for Arrays

def each_with_index(array)
  (0...array.size).each { |idx| yield(array[idx], idx) }
  array
end

result = each_with_index([1, 3, 6]) do |value, index|
  puts "#{index} -> #{value**index}"
end

puts result == [1, 3, 6]
