# Write a program that will take a string of digits and give you all the
# possible consecutive number series of length n in that string.

class Series
  def initialize(string)
    @string = string.chars.map(&:to_i)
  end

  def slices(n)
    raise ArgumentError, "Series size greater than string." if n > @string.size
    result = []
    0.upto(@string.size - n) { |idx| result << @string[idx...idx + n] }
    result
  end
end

# my_s = Series.new('92834')
# p my_s.slices(1)
# p my_s.slices(2)
# p my_s.slices(3)
# p my_s.slices(4)
# p my_s.slices(5)
