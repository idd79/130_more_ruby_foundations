# Pig latin 

# Rule 1: If a word begins with a vowel sound, add an "ay" sound to
# the end of the word.

#Rule 2: If a word begins with a consonant sound, move it to the end of the
#word, and then add an "ay" sound to the end of the word.

class PigLatin
  def self.translate(string)
    string.split.map { |word| translate_word(word) }.join(' ')
  end

  def self.translate_word(word)
    first_vowel_at = if word =~ /\A[^aeiou]?qu/
                       word.index(/[aeio]/)
                     else
                       word.index(/[aeiou]|xr|yt/)
                     end

    word[first_vowel_at..-1] + word[0...first_vowel_at] + 'ay'
  end
end

# p PigLatin.translate('yellow')

# Edge cases

# Starts with qu then move qu to end, e.g. queen
# Starts with consonant preceeding qu (e.g. square), move squ to end
# Starts with xr, then don't move xr to end
# Starts with yt, then don't move yt to end