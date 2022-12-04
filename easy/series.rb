# Solved in 25 minutes

=begin

Problem:
  create a Series class which takes as an argument when instantiated a numeric string
  must have a #slices instance method which returns all possible consecutive number series
    returns them as an array of arrays (of digit integers, not concatentated strings)
    "consecutive" in the sense that they are next to each other in the original numeric string
      (they do not need to be numerically adjacent)
    #slices takes an integer argument, for the requisite length of all the sub-series
    #slices should raise an ArgumentError if passed an integer larger than the size of the string

Data/Algorithm:

raise argumenterror if length > series size
init empty results array
break string into chars array
iterate through chars array with index
  for each iteration, init empty series array
  if chars array size >= index+length
    map all chars from index to index+length-1 into array of integers
    push mapped array into results array

=end

class Series
  def initialize(numeric_string)
    @numeric_string = numeric_string
  end

  def slices(length)
    raise ArgumentError, 'Too big!' if length > @numeric_string.size

    results = []
    digits = @numeric_string.chars.map(&:to_i)
    
    digits.each_with_index do |digit, idx|
      return results if @numeric_string.size < (idx + length)
      sub_series = digits[idx..(idx + length - 1)]
      results << sub_series
    end

    results
  end
end

# LS Solution:

class Series
  attr_accessor :number_string

  def initialize(str)
    @number_string = str
  end

  def slices(length)
    raise ArgumentError.new if length > number_string.size
    number_string.chars.map(&:to_i).each_cons(length).to_a # tight code! #each_cons helps
  end
end
