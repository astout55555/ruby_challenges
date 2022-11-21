=begin

Problem: write code that converts modern decimal numbers into Roman numerals
  -LS provided tests indicate I must define a RomanNumeral class
    -this class takes an integer argument when it is instantiated
    -this class must also have an instance method #to_roman
      -this method returns a string representation of the Roman numeral (e.g. 'VII')

Algorithm:

store initial arg in instance var which can be transformed with #to_roman

# High level algorithm 3: # this one solved the problem initially, but very inefficient

create class constant (array) of roman numerals, I to M

within #to_roman method...
break decimal value into array of digits (keep reversed, starting at rightmost digit)
create empty results array
iterate through digits with index
  lesser, mid, greater = constant[idx*2], constant[idx*2 + 1], constant[idx*2 +2]
    (mid and greater -or 5s and 10s- can be nil when at thousanths place in 4-digit num)
  starting with rightmost digit (first in array), convert to roman num
    next if digit is 0
    if digit is 1-3, push digit * lesser to results
    elsif digit is 4, push lesser and mid to results
      (will break after 3999 because mid is nil, which is okay)
    elsif digit is 5, push mid to results
    elsif digit is 6-8, push mid and 1-3 (digit - 5) * lesser to results
    elsif digit is 9, push lesser and greater to results
join and return results array

# Better Algorithm 1:

(algorithm hint from LS)
Roman Numerals Collection
  Create a collection that links important Roman numeral strings to their numeric counterparts.
  Ensure this is in descending order.
# from here I'll try to build off it and solve this challenge in the intended way...
within #to_roman method...
init var to empty string for results
iterate through digits (reverse to start from leftmost digit) with index
-size of number (number of digits) is what determines conversion to roman num
  -index during iteration can be used to shift conversion, but cannot indicate start position
-can still use 'ones', 'fives', and 'tens' vars to refer to roman nums idx conversion
-start position is: 1 - (digits.size * 2)
  1 => -1 (or 6)
  2 => -3 (or 4)
  3 => -5 (or 2)
  4 => -7 (or 0)
  -this is also position of ones unit, with 5s being - 1 from there, 10s being - 2
-change conversion position by +(idx*2) as iteration continues
-use same control flow (if 0, 1-3, 4, 5, 6-8, 9) as before, but push strings (not arrays)
return results string (no need to flatten or reverse or join)

# LS algorithm, with my additions:
  use nested array to created descending order of roman nums with numeric values

  within #to_roman...
  Initialize a variable with an empty string to save the finished Roman conversion.
  Iterate over the Roman Numerals collection with index:
    If the numeric value of the current Roman numeral is less than the value of the input
        number, add the Roman numerals to the string as many times as its value can fit.
        For instance, if the current Roman numeral is C (which has a value of 100) and the
        input number is 367, then 3 C's are needed: CCC.
      Subtract the numeric value of the added Roman numerals from the current input value,
          and use the new input value in subsequent iterations. For instance, since we added
          CCC to the string above, we must subtract 300 from 367, leaving us with a new input
          number of 67.
      if remaining value has starting digit of 9
        instead push 1 of next roman numeral (idx + 1) and 1 of previous (idx - 1)
        then subtract 9 * next numeric value
      if the remaining value has a starting digit of 4
        instead push 1 of current numeral and one of previous numeral,
        then subtract 4 * current numeric value
  Return the result string.

=end

class RomanNumeral
  # needed ascending order for first solution
  # ROMAN_NUMS = ['I', 'V', 'X', 'L', 'C', 'D', 'M']

  # need descending order for reworked solution
  # ROMAN_NUMS = ['M', 'D', 'C', 'L', 'X', 'V', 'I']

  # for LS algorithm-based solution:
  ROMAN_NUMS = [
    ['M', 1000],
    ['D', 500],
    ['C', 100],
    ['L', 50],
    ['X', 10],
    ['V', 5],
    ['I', 1]
  ]

  def initialize(decimal_num)
    @decimal_num = decimal_num
    # @num_digits = @decimal_num.digits.size # used in reworked solution
  end

  # initial solution I found, which worked, but seems inefficient
  # def to_roman
  #   results = []
  #   @decimal_num.digits.each_with_index do |digit, idx|
  #     ones = ROMAN_NUMS[idx * 2]
  #     fives = ROMAN_NUMS[idx * 2 + 1] # can be nil if at thousanths place
  #     tens = ROMAN_NUMS[idx * 2 + 2] # can also be nil at thousanths digit
  #     if digit == 0
  #       next
  #     elsif digit <= 3
  #       results << [ones * digit]
  #     elsif digit == 4
  #       results << [ones, fives]
  #     elsif digit == 5
  #       results << [fives]
  #     elsif digit <= 8
  #       results << [fives, ones * (digit - 5)]
  #     elsif digit == 9
  #       results << [ones, tens]
  #     end
  #   end

  #   results.reverse.flatten.join
  # end

  # reworked solution--works, but doesn't really seem improved
  # def to_roman
  #   results = ''
  #   @decimal_num.digits.reverse.each_with_index do |digit, idx|
  #     ones = ROMAN_NUMS[1 - ((@num_digits - idx) * 2)]
  #     fives = ROMAN_NUMS[1 - ((@num_digits - idx) * 2) - 1] # wrong value for 1000ths
  #     tens = ROMAN_NUMS[1 - ((@num_digits - idx) * 2) - 2] # but doesn't need to work
  #     if digit == 0
  #       next
  #     elsif digit <= 3
  #       results << (ones * digit)
  #     elsif digit == 4 # >= 4 will not be true for 1000ths place digit, but out of scope
  #       results << ones << fives
  #     elsif digit == 5
  #       results << fives
  #     elsif digit <= 8
  #       results << fives << (ones * (digit - 5))
  #     elsif digit == 9
  #       results << ones << tens
  #     end
  #   end

  #   results
  # end

  # final version of instance method based on LS provided algorithm
  def to_roman
    results = ''
    remaining_value = @decimal_num

    ROMAN_NUMS.each_with_index do |(roman, numeric_val), idx|
      while remaining_value >= numeric_val
        if remaining_value.digits.last == 9
          results << ROMAN_NUMS[idx + 1][0] << ROMAN_NUMS[idx - 1][0]
          remaining_value -= ROMAN_NUMS[idx + 1][1] * 9        
        elsif remaining_value.digits.last == 4
          results << roman << ROMAN_NUMS[idx - 1][0]
          remaining_value -= numeric_val * 4
        else
          results << roman
          remaining_value -= numeric_val
        end
      end
    end

    results
  end
end

## Full LS Solution below:

# class RomanNumeral
#   attr_reader :number # unnecessary, but fine

#   ROMAN_NUMERALS = { # I can't believe I didn't think of just linking the values here!
#     "M" => 1000,
#     "CM" => 900, # putting in the combination values for 9s and 4s saves trouble later
#     "D" => 500,
#     "CD" => 400, # with these in the collection, I don't need to adjust for edge cases.
#     "C" => 100,
#     "XC" => 90,
#     "L" => 50,
#     "XL" => 40,
#     "X" => 10,
#     "IX" => 9,
#     "V" => 5,
#     "IV" => 4,
#     "I" => 1
#   }

#   def initialize(number)
#     @number = number
#   end

#   def to_roman
#     roman_version = ''
#     to_convert = number

#     ROMAN_NUMERALS.each do |key, value| # block params could be better named imo.
#       multiplier, remainder = to_convert.divmod(value) # divmod and multiple assignment
#       if multiplier > 0 # keeps the code more concise.
#         roman_version += (key * multiplier)
#       end
#       to_convert = remainder
#     end
#     roman_version
#   end
# end

### Extra Challenge! Fix the LS solution so it doesn't rely on ordering of pairs in hash!

# This seems simple enough. I just need to find the pair with the max value which is still
# less than the remaining value, and use that. I can select from those which are still less,
# and then return the max from there.

class RomanNumeral
  ROMAN_NUMERALS = { # reversed to prove it works correctly
    "I" => 1,
    "IV" => 4,
    "V" => 5,
    "IX" => 9,
    "X" => 10,
    "XL" => 40,
    "L" => 50,
    "XC" => 90,
    "C" => 100,
    "CD" => 400,
    "D" => 500,
    "CM" => 900,
    "M" => 1000,
  }

  def initialize(number)
    @number = number
  end

  def to_roman
    roman_version = ''
    to_convert = @number

    until to_convert == 0
      roman, value = ROMAN_NUMERALS.select {|_, v| v <= to_convert}.max_by {|_, v| v }
      multiplier, remainder = to_convert.divmod(value)
      roman_version += (roman * multiplier)
      to_convert = remainder
    end

    roman_version
  end
end
