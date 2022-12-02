# Solved in 20 minutes

=begin

Problem:
input: a natural number and an optional set of one or more other numbers
  -default for 2nd arg is 3 and 5
output: sum of all numbers 1...natural_num which are multiples of any num from the set

notes:
  must create a SumOfMultiples class, which takes as its intantiating arg the set of nums
  must include a #to instance method which returns the sum of multiples of the set in 1...num
  must include a #to class method which uses a default set of [3, 5]

Data/Algorithm:

for #to
init sum to 0
iterate from 1...number (not including number)
  for each num, check if num % any factor == 0
    if so, add to sum and next (don't add twice if it works for both factors, e.g.)
return sum

=end

class SumOfMultiples
  attr_reader :multiples

  def initialize(*multiples)
    multiples.empty? ? (@multiples = [3, 5]) : (@multiples = multiples)
  end

  def to(number)
    sum = 0
    (1...number).each do |current_num|
      sum += current_num if @multiples.any? { |factor| current_num % factor == 0 }
    end
    sum
  end

  def self.to(number)
    SumOfMultiples.new.to(number)
    # sum = 0
    # (1...number).each do |current_num|
    #   sum += current_num if current_num % 3 == 0 || current_num % 5 == 0
    # end
    # sum
  end
end

# LS Solution:

class SumOfMultiples
  attr_reader :multiples

  def self.to(num)
    SumOfMultiples.new().to(num)
  end

  def initialize(*multiples) # assignment to return of ternary operation is cleaner syntax
    @multiples = (multiples.size > 0) ? multiples : [3, 5]; 
  end

  def to(num) # selects the multiples from range and then sums selection
    (1...num).select do |current_num|
      any_multiple?(current_num)
    end.sum
  end

  private

  def any_multiple?(num) # private helper method to keep code cleaner above
    multiples.any? do |multiple|
      (num % multiple).zero?
    end
  end
end
