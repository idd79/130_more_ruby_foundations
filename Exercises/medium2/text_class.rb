# text_class.rb

class Text
  def initialize(text)
    @text = text
  end

  def swap(letter_one, letter_two)
    @text.gsub(letter_one, letter_two)
  end

  def word_count
    @text.split.count
  end
end

# content = File.open("sample_text.txt", "r") { |file| file.read }
# text = Text.new(content)

# puts text.swap('m', 'M')
