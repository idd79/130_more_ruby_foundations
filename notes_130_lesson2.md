## Lesson 2 - Introduction to Testing

### Minitest

Though many people use RSpec, Minitest is the default testing library that comes with Ruby. From a pure functionality standpoint, Minitest can do everything RSpec can, except Minitest uses a more straight forward syntax. RSpec bends over backwards to allow developers to write code that reads like natural English, but at the cost of simplicity. RSpec is what we call a __Domain Specific Language__; it's a DSL for writing tests.

We use Minitest because it reads just like normal Ruby code, without a lot of magical syntax. It's not a DSL, it's just Ruby.

#### Vocabulary

- __Test Suite__: this is the entire set of tests that accompanies your program or application. You can think of this as all the tests for a project.
- __Test__: this describes a situation or context in which tests are run. For example, this test is about making sure you get an error message after trying to log in with the wrong password. A test can contain multiple assertions.
- __Assertion__: this is the actual verification step to confirm that the data returned by your program or application is indeed what is expected. You make one or more assertions within a test.

#### Your first test

Let's start with a simple Car class. Create a file called car.rb on your file system, and include the following code.

```ruby
class Car
  attr_accessor :wheels

  def initialize
    @wheels = 4
  end
end
```

Now, in the same directory, create another file called car_test.rb with the following code.

```ruby
require 'minitest/autorun'

require_relative 'car'

class CarTest < MiniTest::Test
  def test_wheels
    car = Car.new
    assert_equal(4, car.wheels)
  end
end
```

If you run the test file with ruby car_test.rb, you should see this output:

```
$ ruby car_test.rb

Run options: --seed 62238

# Running:

CarTest .

Finished in 0.001097s, 911.3428 runs/s, 911.3428 assertions/s.

1 runs, 1 assertions, 0 failures, 0 errors, 0 skips
```

- We use `require_relative` to specify the file name from the current file's directory.
- Line 5 is where we create our test class. Note that this class must subclass `MiniTest::Test`. This will allow our test class to inherit all the necessary methods for writing tests.

Within our test class, `CarTest`, we can write tests by creating an instance method that starts with `test_`. Through this naming convention, Minitest will know that these methods are individual tests that need to be run. Within each test (or instance method that starts with "`test_`"), we will need to make some assertions.

There are many types of assertions, but for now, just focus on `assert_equal` which takes two parameters: the first is the expected value, and the second is the test or actual value. If there's a discrepancy, `assert_equal` will save the error and Minitest will report that error to you at the end of the test run.

- It's sometimes useful to have multiple assertions within one test.

#### A dash of color

The default Minitest output is quite bland, but you can easily add color to the output with the `minitest-reporters` gem. First, install the gem.

```
$ gem install minitest-reporters
```

Then, at the top of your test file, include the following lines:

```ruby
require "minitest/reporters"
Minitest::Reporters.use!
```

Your entire test file should look something like this:

```ruby
require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative 'car'

class CarTest < MiniTest::Test
  def test_wheels
    car = Car.new
    assert_equal(4, car.wheels)
  end

  def test_bad_wheels
    car = Car.new
    assert_equal(3, car.wheels)
  end
end
```

#### Skipping tests

Sometimes you'll want to skip certain tests. Perhaps you are in the middle of writing a test, and do not want it run yet, or for any other reason. Minitest allows for this via the skip keyword. Example:

```ruby
require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative 'car'

class CarTest < MiniTest::Test
  def test_wheels
    car = Car.new
    assert_equal(4, car.wheels)
  end

  def test_bad_wheels
    skip
    car = Car.new
    assert_equal(3, car.wheels)
  end
end
```

#### Expectation Syntax

So far, we've been using the assertion or assert-style syntax. Minitest also has a completely different syntax called expectation or spec-style syntax.

In expectation style, tests are grouped into `describe` blocks, and individual tests are written with the `it` method. We no longer use assertions, and instead use expectation matchers.

```ruby
require 'minitest/autorun'

require_relative 'car'

describe 'Car#wheels' do
  it 'has 4 wheels' do
    car = Car.new
    car.wheels.must_equal 4           # this is the expectation
  end
end
```

Some people prefer the expectation syntax because it mimics RSpec's syntax, but in this course, we're going to stick with the more intuitive assertion style.

### Assertions

`assert_equal` is the most common assertion, and we can get pretty far only using that.

But there are times when we need to make different types of assertions. For example, besides equality, sometimes we want to assert that a specific error is raised, or that something is printed out to standard out, or an object must be an object of a specific class, or that something must be `nil`, or that it must not be `nil`, etc.

There are many type of assertions and a full list can be found [here](http://docs.seattlerb.org/minitest/Minitest/Assertions.html). Here are some of the most popular ones:

Assertion                        | Description
-------------------------------- | -------------------------------
assert(test)                     | Fails unless test is truthy.
assert_equal(exp, act)           | Fails unless exp == act.
assert_nil(obj)                  | Fails unless obj is nil.
assert_raises(*exp) { ... }      | Fails unless block raises one of \*exp.
assert_instance_of(cls, obj)     | Fails unless obj is an instance of cls.
assert_includes(collection, obj) | Fails unless collection includes obj.

Example for `assert_raises`:

```ruby
def test_raise_initialize_with_arg
  assert_raises(ArgumentError) do
    car = Car.new(name: "Joey")         # this code raises ArgumentError, so this assertion passes
  end
end
```

#### Refutations

We won't spend too much talking about refutations, except to say that they are the opposite of assertions. That is, they refute rather than assert. Every assertion has a corresponding refutation. For example, `assert's` opposite is `refute`. `refute` passes if the object you pass to it is falsey. Refutations all take the same arguments, except it's doing a refutation.

#### SEAT Approach

In larger projects, there are usually 4 steps to writing a test:

1. Set up the necessary objects.
1. Execute the code against the object we're testing.
1. Assert the results of the execution.
1. Tear down and clean up any lingering artifacts.

In our simple tests, we've been doing steps 2 and 3, and we haven't had the need to set up anything or perform any clean up or tear down:

Example:

```ruby
require 'minitest/autorun'

require_relative 'car'

class CarTest < MiniTest::Test
  def setup
    @car = Car.new
  end

  def test_car_exists
    assert(@car)
  end

  def test_wheels
    assert_equal(4, @car.wheels)
  end

  def test_name_is_nil
    assert_nil(@car.name)
  end

  def test_raise_initialize_with_arg
    assert_raises(ArgumentError) do
      car = Car.new(name: "Joey")
    end
  end

  def assert_instance_of_car
    assert_instance_of(Car, @car)
  end

  def test_includes_car
    arr = [1, 2, 3]
    arr << @car

    assert_includes(arr, @car)
  end
end
```

#### Testing equality

When we use `assert_equal` we are testing for _value equality_. Specifically, we are invoking the `==` method on the object. If we are looking for more strict `object equality`, then we need the `assert_same` assertion.

Example:

```ruby
require 'minitest/autorun'

class EqualityTest < Minitest::Test
  def test_value_equality
    str1 = "hi there"
    str2 = "hi there"

    assert_equal(str1, str2)
    assert_same(str1, str2)
  end
end

# Output
#   1) Failure:
# EqualityTest#test_value_equality [temp.rb:9]:
# Expected "hi there" (oid=70321861410720) to be the same as "hi there" (oid=70321861410740).
```

#### Equality with a custom class

Because the Ruby standard library classes all implement sensible `==` to test for value equality, we can get away with using `assert_equal` on strings, arrays, hashes, etc. But what happens if we try to use `assert_equal` on our own custom classes?

The answer is we have to tell Minitest how to compare those objects by implementing our own `==` method.

Let's implement Car#==.

```ruby
class Car
  attr_accessor :wheels, :name

  def initialize
    @wheels = 4
  end

  def ==(other)          # assert_equal would fail without this method
    other.is_a?(Car) && name == other.name
  end
end
```

We can now call `assert_equal` on `Car` objects.

```ruby
class CarTest < MiniTest::Test
  def test_value_equality
    car1 = Car.new
    car2 = Car.new

    car1.name = "Kim"
    car2.name = "Kim"

    assert_equal(car1, car2)          # this will pass
    assert_same(car1, car2)           # this will fail
  end
end
```

#### Code coverage

When writing tests, we want to get an idea of _code coverage_, or how much of our actual program code is tested by a test suite. You can see from our `TodoList` tests that all of our public methods are covered. If we are measuring code coverage based on testing the public methods, we could say that we have achieved 100% code coverage. Note that this doesn't mean every edge case is considered, or that even our program is working correctly. It only means that we have some tests in place for every method.

There are many code coverage tools, but we'll use a very simple to use one called `simplecov`:

```
$ gem install simplecov
```

Next, put this at the top of the test file.

```ruby
require 'simplecov'
SimpleCov.start
```

That's it! Next time you run `todolist_test.rb`, you should see a new directory in the file system called coverage. Open up the `index.html`file in that directory, and you should see a report.