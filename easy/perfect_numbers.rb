# Solved in 19 minutes

=begin

Problem: write a program which can tell whether a number is perfect, abundant, or deficient
-if sum of divisors (other than original num) is < num, then num is deficient
  -if equal to num, num is perfect
  -if greater than num, num is abundant

-tests show that we need a PerfectNumber class, which has a class method #classify
-class method #classify takes an integer argument, and returns classification string
-if passed an integer 0 or less, raise a StandardError

Data/Algorithm:

use #initialize and an instance method as a helper method for PerfectNumber#classify
-construct new PerfectNumber object with int argument from #classify, call instance method

smaller problem: find the divisors of a number (so we can classify its sum)
init empty divisors array
from 1 up to num - 1 (range 1...num),
  if current number divides evenly into num, push to divisors array
return sum of array

=end

class PerfectNumber
  def initialize(num)
    @num = num
    raise StandardError 'Must provide integer greater than 0.' if @num <= 0
  end

  def sum_factors
    factors = []
    (1...@num).each do |possible_factor|
      factors << possible_factor if @num % possible_factor == 0
    end
    factors.sum
  end

  def self.classify(num)
    sum = PerfectNumber.new(num).sum_factors
    if sum < num
      'deficient'
    elsif sum == num
      'perfect'
    elsif sum > num
      'abundant'
    end
  end
end

# LS Solution below:

class PerfectNumber # solved without using a constructor, just class methods
  def self.classify(number)
    raise StandardError.new if number < 1 # the #new isn't necessary, it seems
    sum = sum_of_factors(number)

    if sum == number
      'perfect'
    elsif sum > number
      'abundant'
    else
      'deficient'
    end
  end

  class << self # this idiom is needed to add a private class method
    private

    def sum_of_factors(number)
      (1...number).select do |possible_divisor|
        number % possible_divisor == 0
      end.sum
    end
  end
end

# code below would not work as expected--you cannot create private class methods this way:

# class PerfectNumber
#   # omitted code

#   private

#   def self.sum_of_factors(number)
#     (1...number).select do |possible_divisor|
#       number % possible_divisor == 0
#     end.sum
#   end
# end

# nice concise solution from fellow LS student, although perhaps less readable:

class PerfectNumber
  def self.classify(num)
    raise StandardError.new("Number can't be less than 1") if num < 1

    aliquot = (1..num / 2).reduce(0) do |acc, n|
      num % n == 0 ? acc + n : acc
    end

    ['perfect', 'deficient', 'abundant'][num <=> aliquot] # clever
  end
end
