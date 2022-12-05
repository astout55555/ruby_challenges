# Solved in 65 minutes

=begin

Problem: create a symmetrical diamond shape made of letters, starting with A to target at widest point

-create a Diamond class (takes no args at construction)
-includes a #make_diamond class method which takes the target letter

Data/Algorithm:

High Level Plan:

1. build diamond based on max width/height, don't worry about what letters go where
2. modify algorithm to account for changing characters in letter locations

High Level Algorithm:

1. based on letter provided, find max width/height
  -convert letter to numeric value based on position in alphabet
  -use helper method which employs a hash built from range of 1-26 and A-Z
2. build top half of diamond, centering letters from A to given letter, correctly spaced
  -0 spaces at first (first line is a centered A)
  -then spaces between B's etc. with 
3. 
  -and width for letters in each line (max - (2 * distance from center))

build each line of the diamond lines with:
  -find max width/height by size of array built from A-targetletter range
  -build top half by iterating over this array (provides both the count and the symbol)
    -for each letter, build the line using the current letter centered within max width
      -after first line, space double letters apart before centering
        -spaces required are 1, 3, 5, etc., or idx*2 - 1 (except first line, 0)
    -add all lines to a diamond_result array as it is built, as a string
make diamond joining lines 0 upto max with \n separator
  -then concatentate max-1 downto 0 (inverse), joined with \n, to previous half


=end

class Diamond
  def self.make_diamond(target_letter)
    return "A\n" if target_letter == 'A' # to avoid adding extra "\n" for 2nd 'half'

    letter_arr = ('A'..target_letter).to_a
    max_size = letter_arr.size * 2 - 1

    diamond_lines = []

    letter_arr.each_with_index do |letter, line|
      if line.zero?
        line = letter.center(max_size)
      else
        spaces = ' ' * (line * 2 - 1)
        line = "#{letter}#{spaces}#{letter}".center(max_size)
      end

      diamond_lines << line
    end

    # building lines using half + the inverse doesn't work for single-line 'A' diamonds
    first_half = diamond_lines.join("\n")
    second_half = diamond_lines[0...-1].reverse.join("\n")

    first_half + "\n" + second_half + "\n"

    # alternative code is more compact, but perhaps less clear
    # diamond_lines << diamond_lines[0...-1].reverse
    # diamond_lines.join("\n") + "\n"
  end
end

# LS Solution: overall isn't really much clearer than my code, but method is more compact

class Diamond
  def self.make_diamond(letter)
    range = ('A'..letter).to_a + ('A'...letter).to_a.reverse # builds full range upfront
    diamond_width = max_width(letter)
# code can be compact with #max_width and #make_row helper methods
# (these each also call #determine_spaces)
    range.each_with_object([]) do |let, arr|
      arr << make_row(let).center(diamond_width)
    end.join("\n") + "\n"
  end

  class << self # this syntax needed for private class methods
    private

    def make_row(letter)
      return "A" if letter == 'A' # special return value for 'A' line needed even without early return in public method
      return "B B" if letter == 'B' 
# 'B' return line is unnecessary, but allows for structure of loop in #determine_spaces
      letter + determine_spaces(letter) + letter
    end

    def determine_spaces(letter)
      all_letters = ['B']
      spaces = 1

      until all_letters.include?(letter)
        current_letter = all_letters.last
        all_letters << current_letter.next #next returns 'C' when called on 'B', etc.
        spaces += 2
      end

      ' ' * spaces # remember to multiply with the string on the left to use String#*
    end

    def max_width(letter)
      return 1 if letter == 'A'

      determine_spaces(letter).count(' ') + 2
    end
  end
end
