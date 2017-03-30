# Notes on 130 Exercises

## Easy 1

To provide most of the functionality of the Enumerable module, all you need to do is include Enumerable in your class, and define an `each` method that yields each member of the collection, one at a time

```ruby
class Tree
  include Enumerable

  def each
    ...
  end
end
```

## Medium 1

Example of a method that opens a file and yields it:

```ruby
class TextAnalyzer
  def process
    file = File.open('sample_text.txt', 'r')
    yield(file.read)
    file.close
  end
end
```

- If we want to assign multiple variables on one line, we may do that:

```ruby
raven, finch, hawk, eagle = %w(raven finch hawk eagle)
p raven # => 'raven'
p finch # => 'finch'
p hawk # => 'hawk'
p eagle # => 'eagle'
```

But, what if we wanted to organize our array contents into categories, where variables represent category names. Could we do that without directly grabbing certain items from particular array indices?

There is one way to do it, and that is by using the splat operator(*). We can do something like this:

```ruby
raven, finch, *birds_of_prey = %w(raven finch hawk eagle)
p raven # => 'raven'
p finch # => 'finch'
p birds_of_prey # => ['hawk','eagle']
```

### Procs vs Lambdas and blocks

```ruby
# Group 1
my_proc = proc { |thing| puts "This is a #{thing}." }
puts my_proc
puts my_proc.class
my_proc.call
my_proc.call('cat')

# Group 2
my_lambda = lambda { |thing| puts "This is a #{thing}" }
my_second_lambda = -> (thing) { puts "This is a #{thing}" }
puts my_lambda
puts my_second_lambda
puts my_lambda.class
my_lambda.call('dog')
my_lambda.call
my_third_lambda = Lambda.new { |thing| puts "This is a #{thing}" }

# Group 3
def block_method_1(animal)
  yield
end

block_method_1('seal') { |seal| puts "This is a #{seal}."}
block_method_1('seal')

# Group 4
def block_method_2(animal)
  yield(animal)
end

block_method_2('turtle') { |turtle| puts "This is a #{turtle}."}
block_method_2('turtle') do |turtle, seal|
  puts "This is a #{turtle} and a #{seal}."
end
block_method_2('turtle') { puts "This is a #{animal}."}
```

- Group 1:

1. A new Proc object can be created with a call of proc instead of Proc.new
1. A Proc is an object of class Proc
1. A Proc object does not require that the correct number of arguments are passed to it. If nothing is passed, then nil is assigned to the block variable.

- Group 2

1. A new Lambda object can be created with a call to lambda or ->. We cannot create a new Lambda object with Lambda.new
1. A Lambda is actually a different variety of Proc.
1. While a Lambda is a Proc, it maintains a separate identity from a plain Proc. This can be seen when displaying a Lambda: the string displayed contains an extra "(lambda)" that is not present for regular Procs.
1. A lambda enforces the number of arguments. If the expected number of arguments are not passed to it, then an error is thrown.

- Group 3

1. A block passed to a method does not require the correct number of arguments. If a block variable is defined, and no value is passed to it, then nil will be assigned to that block variable.
1. If we have a yield and no block is passed, then an error is thrown.

- Group 4

1. If we pass too few arguments to a block, then the remaining ones are assigned a nil value.
1. Blocks will throw an error if a variable is referenced that doesn't exist in the block's scope.

__Comparison__

Lambdas are types of Proc's. Technically they are both Proc objects. An implicit block is a grouping of code, a type of closure, it is not an Object.
Lambdas enforce the number of arguments passed to them. Implicit block and Procs do not enforce the number of arguments passed in.

- If we return from within a Proc, and that Proc is defined within a method. Then, we will immediately exit that method(we return from the method).

- If we return from within a Proc and that Proc is defined outside of a method. Then, an error will be thrown when we call that Proc. This occurs because program execution jumps to where the Proc was defined when we call that Proc. We cannot return from the top level of the program.

```ruby
my_proc = proc { return }

def check_return_with_proc_2(my_proc)
  my_proc.call
end
```

- If we return from within a Lambda, and that Lambda is defined within a method, then program execution jumps to where the Lambda code is defined. After that, code execution then proceeds to the next line of the method after the #call to that lambda.

- If we return from within a Lambda and that Lambda is defined outside a method, then program execution continues to the next line after the call to that Lambda. This is the same effect as the point above.

- If we return from an implicit block that is yielded to a method, then an error will be thrown. The reason for this error is the same as the one mentioned for Proc. We are trying to return from some code in our program that isn't in a method.

```ruby
def block_method_3
  yield
end

block_method_3 { return }
```

__Comparison__

Procs and implicit blocks sometimes have the same behavior when we return from them. If a Proc is defined outside a method, and we return from it, then we'll get an error. The same thing occurs if we try to return from an implicit block, where the block itself isn't defined in a method. An error is thrown if we try to return from it.

If we try to return from within a Proc that is defined within a method, then we immediately exit the method.

If we try to return from a Lambda, the same outcome occurs, regardless of whether the Lambda is defined outside a method or inside of it. Eventually, program execution will proceed to the next line after the #call to that lambda.

### Method to Proc

We can do something like this using the `&` operator to convert a `Proc` to a `block`:

```ruby
comparator = proc { |a, b| b <=> a }
array.sort(&comparator)
```

The above code will sort the `array` in reverse order.

We can do something similar for methods in the following way:

```ruby
def convert_to_base_8(n)
  n.to_s(8).to_i
end

base8_proc = method(:convert_to_base_8).to_proc

[8,10,12,14,16,33].map(&base8_proc) # => [10, 12, 14, 16, 20, 41]
```

### Internal vs external iterators

Internal iterators are things such as `map` and `each`. For external iterators we use the `Enumerator` class. The documentation can be found [here](https://ruby-doc.org/core-2.2.0/Enumerator.html).

Example: (based on Medium 1 exercise)

```ruby
factorial = Enumerator.new do |yielder|
  accumulator = 1
  number = 0
  loop do
    accumulator = number.zero? ? 1 : accumulator * number
    yielder << accumulator
    number += 1
  end
end

7.times { puts factorial.next }

factorial.rewind

factorial.each_with_index do |number, index|
  puts number
  break if index == 6
end
```
