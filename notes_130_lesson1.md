# Notes - Course 130 - More topics on Ruby foundations

## Lesson 1 - Blocks

There are three main ways to work with closures in Ruby (or Proc objects):

1. Instantiating an object from the Proc class
1. Using lambdas
1. Using blocks

### Calling methods with blocks

If you've ever written any code with a `do ... end` or `{ ... }`, then you've written blocks before.

The block is an argument to the method call. In other words, our familiar method, `[1, 2, 3].each { |num| puts num }`, is actually _passing in_ the block of code to the `Array#each` method.

The entire block is _passed in_ to the method like any other parameter, and it's up to the method implementation to decide what to do with the block, or chunk of code, that you passed in. The method could take that block and execute it, or just as likely, it could completely ignore it -- it's up to the method implementation to decide what to do with the block of code given to it.

Therefore, _blocks_ are just another parameter being passed in to a method at method invocation time, and so we can write our own methods that take blocks.

### Writing Methods that take Blocks

Believe it or not, every method you have ever written in Ruby already takes a block. Let's implement a simple method.

```ruby
def hello
  "hello!"
end

hello                                    # => "hello!"
```

Now, as expected

```ruby
hello("hi")                              # => ArgumentError: wrong number of arguments (1 for 0)
```

However, something we might not have expected is the following:

```ruby
hello { puts 'hi' }                      # => "hello!"
```

And this is because in Ruby, every method can take an optional block as an implicit parameter

Let's take a look at another example:

```ruby
def echo(str)
  str
end

echo                                          # => ArgumentError: wrong number of arguments (0 for 1)
echo("hello!")                                # => "hello!"
echo("hello", "world!")                       # => ArgumentError: wrong number of arguments (2 for 1)

# this time, called with an implicit block
echo { puts "world" }                         # => ArgumentError: wrong number of arguments (0 for 1)
echo("hello!") { puts "world" }               # => "hello!"
echo("hello", "world!") { puts "world" }      # => ArgumentError: wrong number of arguments (2 for 1)
```

#### Yielding

One way that we can invoke the passed-in block argument from within the method is by using the yield keyword. Let's modify our echo method implementation and yield to the block.

```ruby
def echo_with_yield(str)
  yield
  str
end

echo_with_yield { puts "world" }                        # => ArgumentError: wrong number of arguments (0 for 1)
echo_with_yield("hello!") { puts "world" }              # world
                                                        # => "hello!"
echo_with_yield("hello", "world!") { puts "world" }     # => ArgumentError: wrong number of arguments (2 for 1)
```

Likewise, if we don't pass a block in the above method, we are going to get an error given that the method is necessarily expecting a block due to the `yield` statement:

```ruby
echo_with_yield("hello!")                          # => LocalJumpError: no block given (yield)
```

To avoid this we can use `yield if block.given?`.

#### Yielding with an argument

We have been doing this for long time. For example:

```ruby
3.times do |num|
  puts num
end
```

`num` in this case is a _block local variable_ and its scope is constrained to the block.

Example:

```ruby
# method implementation
def increment(number)
  if block_given?
    yield(number + 1)
  else
    number + 1
  end
end

# method invocation
increment(5) do |num|
  puts num
end
```

In this case, 6 will be printed to the screen. `num` refers to the argument passed to `yield`, that is, `(number + 1)`. The line `yield(number + 1)` what is does is to yield to the block or `call the block` and we are passing `number + 1` as an argument to the block.

Remember that blocks can be interpreted as a un-named or anonymous method which we call with `yield`. Once again, calling a block is almost like calling another method. In this case, we're even passing an argument to the block, just like we could for any normal method.

What would happen if I pass in the wrong number of arguments to a block?. Would Ruby raise an `ArgumentError`, like it would for normal methods? Let's give that scenario a try.

```ruby
# method implementation
def test
  yield(1, 2)                           # passing 2 block arguments at block invocation time
end

# method invocation
test { |num| puts num }                 # expecting 1 parameter in block implementation

# => 1
```

So it doesn't raise an error, it just print to the screen 1 and the extra block argument is ignored.

```ruby
# method implementation
def test
  yield(1)                              # passing 1 block argument at block invocation time
end

# method invocation
test do |num1, num2|                    # expecting 2 parameters in block implementation
  puts "#{num1} #{num2}"
end

# => 1 
```

Even more surprisingly, this also outputs 1. But this output is different from the previous one. In this case, num2 block local variable is nil, so the string interpolation converted that to an empty string, which is why we get 1 (there's an extra space).

The other two ways are instantiating a `Proc` object and using `lambda`. The rules around enforcing the number of arguments you can call on a closure in Ruby is called its `arity`. In Ruby, blocks have lenient arity rules, which is why it doesn't complain when you pass in different number of arguments; `Proc` objects and `lambdas` have different arity rules. For now, don't worry too much about this, but just realize that blocks don't enforce argument count, unlike normal methods in Ruby.

#### Return value of yielding to the block

Suppose we want to write a method that outputs the before and after of manipulating the argument to the method. For example, we'd like to invoke a compare method that does this:

```ruby
def compare(str)
  puts "Before: #{str}"
  after = yield(str)
  puts "After: #{after}"
end

# method invocation
compare('hello') { |word| word.upcase }

# The output from the method invocation is:

# => Before: hello
# => After: HELLO
# => nil
```

From the above example, you can see that the after local variable in the compare method implementation is assigned the return value from the block. This is yet another behavior of blocks that's similar to normal methods: they have a return value, and that return value is determined based on the last expression in the block.

This implies that just like normal methods, blocks can either mutate the argument with a destructive method call or the block can return a value. Just like writing good normal methods, writing good blocks requires you to keep this distinction in mind. Note that the last line, `=> nil`, is the return value of the compare method, and isn't related to what we're doing in the block. The last expression in the `compare` method is a puts, and therefore the return value of calling `compare` is always `nil`.

Other examples:

```ruby
compare('hello') { |word| word.slice(1..2) }

# Before: hello
# After: el
# => nil

compare('hello') { |word| "nothing to do with anything" }

# Before: hello
# After: nothing to do with anything
# => nil

compare('hello') { |word| puts "hi" }

# Before: hello
# hi
# After:
# => nil
```

#### When to use blocks in your own methods

There are many ways that blocks can be useful, but the two main use cases are:

- _Defer some implementation code to method invocation decision_.

Let's first talk about life without blocks. Without using blocks, the method implementor can allow method callers to pass in some flag. For example,

```ruby
def compare(str, flag)
  after = case flag
          when :upcase
            str.upcase
          when :capitalize
            str.capitalize
          # etc, we could have a lot of 'when' clauses
          end

  puts "Before: #{str}"
  puts "After: #{after}"
end

compare("hello", :upcase)

# Before: hello
# After: HELLO
# => nil
```

But this isn't nearly as flexible as allowing method callers a way to refine the method implementation, without actually modifying the method implementation for every one else. By using blocks, the method implementor can defer the decision of which flags to support and let the method caller decide at method invocation time.

If you encounter a scenario where you're calling a method from multiple places, with one little tweak in each case, it may be a good idea to try implementing the method in a generic way by yielding to a block.

- _Methods that need to perform some "before" and "after" actions - sandwich code._

Suppose we want to write a method that outputs how long something takes. Our method doesn't care what that something is; our method just cares about displaying how long it took:

```ruby
def time_it
  time_before = Time.now
  yield
  time_after= Time.now

  puts "It took #{time_after - time_before} seconds."
end

time_it { sleep(3) }                    # It took 3.003767 seconds.
                                        # => nil

time_it { "hello world" }               # It took 3.0e-06 seconds.
                                        # => nil
```

#### Methods with an explicit block parameter

 Up to now, we've been talking about implicitly passing in blocks into methods. Every method, regardless of its method definition, takes an implicit block (though, it may just ignore the implicit block). Sometimes, you'll want to implement a method that explicitly takes a block. Let's take a look at some code.

```ruby
def test(&block)
  puts "What's &block? #{block}"
end
```

The `&block` is a special parameter that will convert the implicitly passed in block into a `Proc` object. Notice that we drop the `&` when using the parameter in the method implementation. Let's invoke the method to see:

```ruby
test { sleep(1) }

# What's &block? #<Proc:0x007f98e32b83c8@(irb):59>
# => nil
```

The block local variable is now a `Proc` object. Note that we can name it whatever; it doesn't have to be &block, as long as it has a leading `&`.

If you ever see a method definition with a `&` in front of the parameter, just remember that this is saving the block into a variable. You can invoke the block with the `call` method (example: `block.call` instead of yielding), or you can pass this block into another method.

### Blocks and variable scope

#### Closure and binding

Take a look at the following code:

```ruby
def call_me(some_code)
  some_code.call            # call will execute the "chunk of code" that gets passed in
end

name = "Robert"
chunk_of_code = Proc.new {puts "hi #{name}"}

call_me(chunk_of_code)
# Output:
# hi Robert
# => nil
```

Note that the `chunk_of_code` knew how to handle puts `#{name}`, and specifically that it knew how to process the name variable. How did it do that? The name variable was initialized outside the method definition, and we know that in Ruby local variables initialized outside the method aren't accessible inside the method, unless it's explicitly passed in as an argument. Let's explore this further:

```ruby
def call_me(some_code)
  some_code.call
end

name = "Robert"
chunk_of_code = Proc.new {puts "hi #{name}"}
name = "Griffin III"        # re-assign name after Proc initialization

call_me(chunk_of_code)

# The output is:

# hi Griffin III
# => nil
```

So even re-assigning the variable after the `Proc` is initialized updates the `chunk_of_code`. This implies that the `Proc` keeps track of its surrounding context, and drags it around wherever the chunk of code is passed to. In Ruby, we call this its __binding__, or surrounding environment/context. A closure must keep track of its surrounding context in order to have all the information it needs in order to be executed later. This not only includes local variables, but also method references, constants and other artifacts in your code.

### Symbol to Proc

As we know, we can write something like this:

```ruby
[1, 2, 3, 4, 5].map(&:to_s)                     # => ["1", "2", "3", "4", "5"]

# which is the same as

[1, 2, 3, 4, 5].map { |n| n.to_s }
```

In the above example `(&:to_s)` gets converted into `{ |n| n.to_s }`. In other words, a block.

So two things are happening:

- First, Ruby sees if the object after `&` is a `Proc`. If it's not, it'll try to call `to_proc` on the object, which should return a `Proc` object. If not, this won't work.
- Then, the & will turn the `Proc` into a block.

This means that Ruby is trying to turn `:to_s` into a block, but it's not a `Proc`, it's a Symbol. Ruby will then try to call the `Symbol#to_proc` method -- and there is one! This method will return a `Proc` object, which will execute the method based on the name of the symbol.

Two more examples:

```ruby
def my_method
  yield(2)
end

# turns the symbol into a Proc, then & turns the Proc into a block
my_method(&:to_s)               # => "2"

# The code example below will try to break up the 2 steps.

def my_method
  yield(2)
end

a_proc = :to_s.to_proc          # explicitly call to_proc on the symbol
my_method(&a_proc)              # convert Proc into block, then pass block in. Returns "2"
```
