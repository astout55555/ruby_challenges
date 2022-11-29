=begin

Problem:

input: a word, and a list of possible anagrams
output: the correct sublist with the anagrams of the word

-create `Anagram` class
  -takes a string (a word) argument when instantiated
  -must be stored as an instance variable (@word)
-has a `match` instance method which works as follows:
  -input: an array argument, a list of possible anagrams
  -output: the correct sublist (an array) with the anagrams of @word
-should return empty array if no anagrams found
-should not include word which is identical (does not count as anagram) in results array
  (case-insensitive matching)
-anagrams must use all letters, no extra ('goody' is not an anagram of 'good')
-anagrams should be case-insensitive

Algorithm for #match:

-init empty results array
-init var for downcased + sorted letters of @word
-iterate through input array
  -if current_word != @word,
    push into results list if .downcase.chars.sort == letters
-return results array

=end

class Anagram
  def initialize(word)
    @word = word
  end

  def match(possible_anagrams)
    actual_anagrams = []
    letters = @word.downcase.chars.sort
    possible_anagrams.each do |current_word|
      next if current_word.downcase == @word.downcase
      actual_anagrams << current_word if current_word.downcase.chars.sort == letters
    end
    actual_anagrams
  end
end
