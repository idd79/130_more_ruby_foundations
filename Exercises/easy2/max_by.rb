# Implement a max_by method for Arrays

def max_by(array)
  return nil if array.empty?

  result = array.map { |value| yield(value) }
  array[result.index(result.max)]

  # max_elm = array.first
  # largest = yield(max_elm)
  # array[1..-1].each do |value|
  #   if largest < yield(value)
  #     max_elm = value
  #     largest = yield(value)
  #   end
  # end

  # max_elm
end

p max_by([1, 5, 3]) { |value| value + 2 } == 5
p max_by([1, 5, 3]) { |value| 9 - value } == 1
p max_by([1, 5, 3]) { |value| (96 - value).chr } == 1
p max_by([[1, 2], [3, 4, 5], [6]]) { |value| value.size } == [3, 4, 5]
p max_by([-7]) { |value| value * 3 } == -7
p max_by([]) { |value| value + 5 } == nil
