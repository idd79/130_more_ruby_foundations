# chash_register_test.rb

require "minitest/autorun"
require "minitest/reporters"
MiniTest::Reporters.use!

require_relative 'cash_register.rb'
require_relative 'transaction.rb'

class CashRegisterTest < MiniTest::Test
  def setup
    @ini_amt = 1_000
    @item_cost = 500
    @amt_paid = 500
    @transaction = Transaction.new(@item_cost)
    @register = CashRegister.new(@ini_amt)
    @transaction.amount_paid = @amt_paid
  end

  def test_accept_money
    assert_equal(@ini_amt + @amt_paid, @register.accept_money(@transaction))
  end

  def test_change
    assert_equal(@amt_paid - @item_cost, @register.change(@transaction))
  end

  def test_give_receipt
    msg = "You've paid $#{@item_cost}.\n"
    # assert_output(stdout = msg) { @register.give_receipt(@transaction) }
    assert_output(msg) { @register.give_receipt(@transaction) }
  end

  def test_prompt_for_payment
    input = StringIO.new('600\n')
    msg = "You owe $#{@item_cost}.\nHow much are you paying?\n"
    assert_output(msg) { @transaction.prompt_for_payment(input: input) }
    assert_equal(600, @transaction.amount_paid)
  end

  def test_prompt_for_payment2
    input = StringIO.new('600\n')
    capture_io { @transaction.prompt_for_payment(input: input) }
    assert_equal(600, @transaction.amount_paid)
  end
end
