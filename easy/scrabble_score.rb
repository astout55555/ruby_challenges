=begin

Problem: write a program that computes the Scrabble score for a given word

-define a Scrabble class which takes a word (string) argument at instantiation
  -can also be passed nil, which should return a score of 0 (not an error)
  -word can be an empty string or contain whitespace, which should not count toward score
    (score should be 0 if no letters are in the string)
-#initialize should store word argument as instance var
-Scrabble objects need a #score instance method that returns the Scrabble score
  (scoring should be case-insensitive)
-score is based on following table of letters/values:

Value: Letter(s)
1: A, E, I, O, U, L, N, R, S, T
2: D, G
3: B, C, M, P
4: F, H, V, W, Y
5: K
8: J, X
10: Q, Z

ALSO NEEDED: a class method Scrabble#score which can be passed a word directly for scoring

Algorithm/Data:

use constant hash for the values (keys) and letters (values; arrays of letters)

store @word as upcased string, stripped of whitespace

for #score:
-init score at 0
-unless @word is nil or '', break @word into chars and iterate through
  -for each letter, iterate through HASH and increment score by key if value includes letter
-return score

=end

class Scrabble
  LETTER_VALUES = {
    1 => ['A', 'E', 'I', 'O', 'U', 'L', 'N', 'R', 'S', 'T'],
    2 => ['D', 'G'],
    3 => ['B', 'C', 'M', 'P'],
    4 => ['F', 'H', 'V', 'W', 'Y'],
    5 => ['K'],
    8 => ['J', 'X'],
    10 => ['Q', 'Z']
  }
  
  def initialize(word)
    @word = word
  end

  def score
    score = 0

    return score if @word.nil?

    @word.strip.upcase.chars.each do |letter|
      LETTER_VALUES.each do |points, letters|
        score += points if letters.include?(letter)
      end
    end

    score
  end

  def self.score(word)
    Scrabble.new(word).score

    # I could simply copy the code here, but the hint suggests I take advantage
    # of the Score constructor and #score instance method, which I use above.
    # this is much more concise than what I had originally put below!

    # score = 0

    # return score if word.nil?

    # word.strip.upcase.chars.each do |letter|
    #   LETTER_VALUES.each do |points, letters|
    #     score += points if letters.include?(letter)
    #   end
    # end

    # score
  end
end

# LS Solution below:

class Scrabble
  attr_reader :word

  POINTS = { # letters are put into a single string, easier to type out and use regex
    'AEIOULNRST'=> 1,
    'DG' => 2,
    'BCMP' => 3,
    'FHVWY' => 4,
    'K' => 5,
    'JX' => 8,
    'QZ' => 10
  }

  def initialize(word)
    @word = word ? word : '' # assigns '' to @word if word was `nil`
  end

  def score
    letters = word.upcase.gsub(/[^A-Z]/, '').chars # replaces all non-letter chars with ''
    # LS solution is more thorough, can account for/remove special or numeric chars too
    total = 0 # same solution I had from here
    letters.each do |letter|
      POINTS.each do |all_letters, point|
        total += point if all_letters.include?(letter)
      end
    end
    total
  end

  def self.score(word)
    Scrabble.new(word).score
  end
end
