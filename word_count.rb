=begin
Write your code for the 'Word Count' exercise in this file. Make the tests in
`word_count_test.rb` pass.

To get started with TDD, see the `README.md` file in your
`ruby/word-count` directory.
=end
# count occurences of each word
# send all letters to lowercase
# words can be all letters or all numbers
# words can have 1 apostrophe at most
# words are separated by any sort of whitespace (ellipses?)
#

class Phrase
  @@word_count
  @@value
  WORD_SEPARATORS = [/[[:space:]]/, /,/, /\.{2,}/].freeze

  def initialize(value)
    @@value = value
    @@word_count = get_word_count(value)
  end

  def word_count
    @@word_count
  end

  def set_value(new_value)
    @@value = new_value
    @@word_count = get_word_count(new_value)
  end

  def get_word_count(value)
    lowercase_value = value.downcase
    is_numeric = false
    is_letter = false
    apostrophes = 0
    current_word = ''
    word_count = {}

    lowercase_value.each_char do |c|

      WORD_SEPARATORS.each do |separator|
        separator.match(c) do |m|
          # add current_word to word count as long as it is a valid word
          unless current_word.empty? || (is_numeric && is_letter) || apostrophes > 1
            increment_word_count(current_word, word_count)

            # reset word trackers
            current_word = ''
            is_numeric = false
            is_letter = false
            apostrophes = 0
          end
        end
      end

      # in the case of numeric character, make sure the word so far is numeric too
      /[[:digit:]]/.match(c) do |m|
        current_word += m[0] unless is_letter #b1a45cdf hello
        is_numeric = true
      end

      # same for letters as numbers
      /[[:alpha:]]/.match(c) do |m|
        current_word += m[0] unless is_numeric
        is_letter = true
      end

      #apostrophes are valid between letters, and only once
      /'/.match(c) do |m|
        unless current_word.empty?
          current_word += m[0] unless is_numeric || apostrophes > 1
          apostrophes += 1
        end
      end
    end
    increment_word_count(current_word, word_count) unless current_word.empty?

    word_count
  end

  def increment_word_count(current_word, word_count)
    # remove a trailing single quote as those aren't valid apostrophes
    current_word = current_word[0...current_word.length - 1] if current_word[current_word.length - 1] == '\''

    if word_count[current_word]
      word_count[current_word] += 1
    else
      word_count[current_word] = 1
    end
  end
end
