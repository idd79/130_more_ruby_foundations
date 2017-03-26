# Find missing numbers

def missing(array)
  first = array.first
  last = array.last

  # (first..last).to_a.map { |num| num unless array.include?(num) }.compact
  (first..last).reject { |num| array.include? num }
end

def missing2(nums)
  (nums.min..nums.max).to_a - nums
end

p missing([-3, -2, 1, 5])

p missing([-3, -2, 1, 5]) == [-1, 0, 2, 3, 4]
p missing([1, 2, 3, 4]) == []
p missing([1, 5]) == [2, 3, 4]
p missing([6]) == []