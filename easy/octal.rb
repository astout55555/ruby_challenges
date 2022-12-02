# Solved in 21 minutes

=begin

Problem: implement octal to decimal conversion
input: octal input string
output: decimal output

notes:
  invalid input is equivalent to octal 0 (aka 0)
    -8, 9, and non-numeric strings are invalid for octal strings
  must create an `Octal` class which takes the octal input string as arg when instantiated
  must have a #to_decimal instance method which returns the decimal output

Data/Algorithm:

set instance var to input octal string
  change to '0' if input contains any forbidden chars
in #to_decimal
  convert string into number, then break into digits
  init sum to 0
  iterate through digits with index, starting with rightmost
    multiply digit by 8 to the power of index, add to sum
  return sum

=end

class Octal
  def initialize(octal_string)
    @octal_string = octal_string
  end

  def to_decimal
    return 0 if @octal_string.match(/[^0-7]/)
    digits = @octal_string.to_i.digits
    decimal_sum = 0
    digits.each_with_index do |digit, idx|
      decimal_sum += digit * (8**idx)
    end
    decimal_sum
  end
end

# LS Solution below:

class Octal
  attr_reader :number

  def initialize(str)
    @number = str
  end

  def to_decimal
    return 0 unless valid_octal?(number)

    arr_digits = number.to_i.digits

    new_number = 0
    arr_digits.each_with_index do |num, exponent|
      new_number += (num * (8 ** exponent))
    end

    new_number
  end

  private

  def valid_octal?(num) # helper method makes code above more readable
    num.chars.all? {|n| n =~ /[0-7]/} # the  `=~` may be better than using #match
  end
end
