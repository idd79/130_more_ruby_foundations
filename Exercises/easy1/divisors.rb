# Write a method that returns a list of all of the divisors of the positive
# integer passed in as an argument. The return value can be in any sequence you
# wish.

def divisors(num)
  1.upto(num).select { |x| num % x == 0 }
end

def divisors2(num)
  sq_num = Math.sqrt(num)
  first_half = 1.upto(sq_num).select { |x| num % x == 0 }
  second_half = first_half.map { |x| num / x }.sort

  first_half + second_half
end

p divisors2(98)
p divisors2(99400891)
p divisors2(999962000357)

# p divisors(1) == [1]
# p divisors(7) == [1, 7]
# p divisors(12) == [1, 2, 3, 4, 6, 12]
# p divisors(98) == [1, 2, 7, 14, 49, 98]
# p divisors(99400891) == [1, 9967, 9973, 99400891] # may take a minute
