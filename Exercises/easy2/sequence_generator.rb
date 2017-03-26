# From-To-Step Sequence Generator

# Write a method that does the same thing as Range#step, but does not operate on
# a range. Instead, your method should take 3 arguments: the starting value, the
# ending value, and the step value to be applied to each iteration.

def step(str_vl, end_vl, step)
  (str_vl..end_vl).step(step) { |num| yield num }
end

def step2(str_vl, end_vl, step)
  str_vl.step(end_vl, step) { |num| yield num }
end

def step3(str_vl, end_vl, step)
  i = str_vl
  while i <= end_vl
    yield i
    i += step
  end
end

p step2(1, 10, 3) { |value| puts "value = #{value}" }
p step3(1, 10, 3) { |value| puts "value = #{value}" }
