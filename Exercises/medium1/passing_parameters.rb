# Passing parameters Part 1

items = ['apples', 'corn', 'cabbage', 'wheat']

def gather(items)
  puts "Let's start gathering food."
  yield(items)
  puts "Let's start gathering food."
end

gather(items) { |produce| puts items.join(', ') }
gather(items) do |produce|
  puts "We've gathered some vegetables: #{produce[1]} and #{produce[2]}"
end

# 1
gather(items) do |*produce, wheat|
  puts produce.join(', ')
  puts wheat
end

# 2
gather(items) do |apples, *vegetables, wheat|
  puts apples
  puts vegetables.join(', ')
  puts wheat
end

# 3
gather(items) do |apples, *assorted|
  puts apples
  puts assorted.join(', ')
end

# 4
gather(items) do |apples, corn, cabbage, wheat|
  puts "#{apples}, #{corn}, #{cabbage}, and #{wheat}"
end

birds = ['crow', 'finch', 'hawk', 'eagle']

def types(birds)
  yield birds
end

types(birds) do |_,_,*birds_of_prey|
  puts "Two birds of prey are the #{birds_of_prey.join(' and ')}."
end
