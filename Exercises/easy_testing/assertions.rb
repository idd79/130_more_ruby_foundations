# Write a minitest assertion that will fail if the `value.odd?' is not true.

require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

class Test < Minitest::Test
  def test_value_odd
    value = 3
    assert_equal(true, value.odd?)
  end

  def test_value_downcase
    value = 'xyz'
    assert_equal 'xyz', value.downcase
    # assert_equal('xyz', value.downcase)
  end

  def test_value_nil
    value = nil
    assert_nil(value)
  end

  def test_array_empty
    list = []
    assert_empty(list)
    # assert_equal(true, list.empty?)
  end

  def test_array_includes_value
    value = 'xyz'
    list = [value]
    assert_includes(list, value)
    # assert_equal(true, list.include?(value))
  end

  def test_raise_error
    skip    # skip as no employee instance has been created
    assert_raise(NoExperienceError) { employee.hire }   
  end

  def test_instance_of_numeric
    value = Numeric.new
    assert_instance_of(Numeric, value)
  end

  def test_instance_of_numeric_non_greedy
    value = 3
    # This assertion uses Object#kind_of?
    assert_kind_of(Numeric, value)
  end

  def test_same_object
    skip
    # This assertion uses Object#equal?
    assert_same(list, list.process)
  end

  def test_value_included_list
    value = 'xyz'
    list = [value]
    refute_includes(list, value)
  end
end