# Write your own version of zip that does the same type of operation.

def zip(ar1, ar2)
  result = []
  ar1.each_with_index { |x, i| result << [x, ar2[i]] }
  result
end

p zip([1, 2, 3], [4, 5, 6]) == [[1, 4], [2, 5], [3, 6]]
