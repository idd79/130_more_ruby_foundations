# Text analyzer - Sandwich code

class TextAnalyzer
  def initialize(file_name)
    @file = file_name
  end

  def process
    File.open(@file, 'r') { |file| yield(file.read) }
  end

  def self.count_paragraphs(file)
    file.split("\n\n").count
  end

  def self.count_lines(file)
    file.split("\n").count
  end

  def self.count_words(file)
    # file.split(" ").count
    file.split.count
  end
end

analyzer = TextAnalyzer.new('./text_analyzer.txt')
analyzer.process { |file| puts "#{TextAnalyzer.count_paragraphs(file)} paragraphs" }
analyzer.process { |file| puts "#{TextAnalyzer.count_lines(file)} lines" }
analyzer.process { |file| puts "#{TextAnalyzer.count_words(file)} words" }
