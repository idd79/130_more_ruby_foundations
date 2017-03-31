# chash_register_test.rb

require "minitest/autorun"
require "minitest/reporters"
MiniTest::Reporters.use!

require_relative 'text_class.rb'

class TextTest < MiniTest::Test
  def setup
    content = File.open("sample_text.txt", "r") { |file| file.read }
    @text = Text.new(content)
  end

  def test_swap
    expected = <<~TEXT 
    LoreM ipsuM dolor sit aMet, consectetur adipiscing elit. Cras sed
    vulputate ipsuM. Suspendisse coMModo seM arcu. Donec a nisi elit.
    NullaM eget nisi coMModo, volutpat quaM a, viverra Mauris. Nunc verra
    sed Massa a condiMentuM. Suspendisse ornare justo nulla, sit aMet
    Mollis eros sollicitudin et. EtiaM MaxiMus Molestie eros, sit aMet
    dictuM dolor ornare bibenduM. Morbi ut Massa nec loreM tincidunt
    eleMentuM vitae id Magna. Cras et varius Mauris, at pharetra Mi.
    TEXT
    actual_text = @text.swap('m', 'M')
    assert_equal(expected, actual_text)
  end

  def test_word_count
    assert_equal(72, @text.word_count)
  end
end
