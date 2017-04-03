# palindrome_products.rb

require "prime"

class Palindromes

  def initialize(args)
    @max_factor = args.fetch(:max_factor)
    @min_factor = args.fetch(:min_factor, 1)
    @num_dgs = @max_factor.digits.count
  end

  Palindrome = Struct.new(:factors, :value)

  def generate
    hash = {}
    palindromes.each { |elm| hash[elm] = two_factors(elm) }
    @palindromes = hash.reject { |_, v| v.empty? }.keys
  end

  def largest
    Palindrome.new(two_factors(@palindromes[-1]), @palindromes[-1])
  end

  def smallest
    Palindrome.new(two_factors(@palindromes[0]), @palindromes[0])
  end

  # Return the unique prime factorization. Example: factors(20) => [2, 2, 5]
  def factors(num)
    factors = Prime.prime_division(num)
    result = []
    factors.each { |factor, power| result += [factor] * power }
    result
  end

  # Return all palindromes withing range (min..max)
  def palindromes
    max, min = (@max_factor**2).to_s, min = @min_factor.to_s
    result = (min..max).select { |elm| elm == elm.reverse }
    result.map { |num| num.to_i }
  end

  # Return two-factors factorization, each factor with @num_dgs number of digits
  def two_factors(num)
    factors = factors(num)
    first_factor = 1
    result = []
    factors.reverse_each do |number|
      next if (first_factor * number).digits.count > @num_dgs
      first_factor *= number
      second_factor = num / first_factor
      result << [first_factor, second_factor].sort
    end
    result.select { |array| array.all? { |elm| elm.digits.count == @num_dgs } }
  end
end

# palindrome = Palindromes.new(max_factor: 99, min_factor: 10)
# # palindrome = Palindromes.new(max_factor: 999, min_factor: 100)
# palindrome = Palindromes.new(max_factor: 9)
# p palindrome.generate
# largest = palindrome.largest
# p largest.value
# p largest.factors
# smallest = palindrome.smallest
# p smallest.value
# p smallest.factors

def factors(num)
  factors = Prime.prime_division(num)
  result = []
  factors.each { |factor, power| result += [factor] * power }
  result
end

def two_factors(num, num_dgs)
  factors = factors(num)
  first_factor = 1
  result = []
  factors.reverse_each do |number|
    next if (first_factor * number).digits.count > num_dgs
    first_factor *= number
    result << [first_factor, num / first_factor].sort
  end
  result.reject { |array| array.any? { |elm| elm.digits.count != num_dgs } }
end

# p factors(99)
# p two_factors(9, 1)