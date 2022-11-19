=begin

# Problem:

Write a program to determine whether a triangle is equilateral, isosceles, or scalene.
  -I'm not just writing a method to check if 3 numbers would form such a triangle,
    I actually need to create a Triangle class with a #kind instance method
    -this #kind instance method should return 'equilateral', 'isosceles', or 'scalene'

smaller problem 1: #initialize should raise an ArgumentError if given impossible lengths
  -no length should be 0 or negative
  -the largest length must be less than the others combined

smaller problem 2: define the #kind instance method so it returns the correct string value
  -I will need to be able to access the numeric value of the triangle's sides
  -the triangle sides are provided at instantiation, as integers
    -I can store them as instance variables

input: indirectly, the 3 side lengths (instance vars)--integers
output: appropriate string representing the type of triangle

# Examples/Tests:
-provided by LS, copied into testing file
-the tests show me that I need to create an appropriate class definition only
-I will need to remove the `skip` at the beginning of each test as I go, eventually all

# Algorithm for #initialize (problem 1):

1. in initialize, set sides to side instance variables
2. place all 3 vars into an array, and sort
3. if largest size >= other sides combined, raise ArgumentError
4. if any length in ordered list is <= 0, raise ArgumentError

# Algorithm for #kind (problem 2):

illegal triangles have already been ruled out after #initialize, so...
using ordered_lengths instance var
  if first == last, return equilateral
  if 0 == 1 or 1 == 2, it's isosceles
  otherwise it's scalene

=end

class Triangle
  def initialize(side1, side2, side3)
    @side1 = side1
    @side2 = side2
    @side3 = side3
    @ordered_lengths = [@side1, @side2, @side3].sort
    if @ordered_lengths[2] >= @ordered_lengths[0..1].sum ||
       @ordered_lengths.any? { |side| side <= 0 }
      raise ArgumentError
    end
  end

  def kind
    return 'equilateral' if @ordered_lengths[0] == @ordered_lengths[2]
    return 'isosceles' if @ordered_lengths[0] == @ordered_lengths[1] ||
                          @ordered_lengths[1] == @ordered_lengths[2]
    'scalene'
  end
end

### LS Solution:

class Triangle
  attr_reader :sides # I chose to expose less, but this seems likely needed

  def initialize(side1, side2, side3)
    @sides = [side1, side2, side3] # immediately collects sides into array
    raise ArgumentError.new "Invalid triangle lengths" unless valid? # added message :)
  end # private #valid? method keeps #initialize clean

  def kind # using #uniq makes this simpler, removes need for sorting lengths
    if sides.uniq.size == 1
      'equilateral'
    elsif sides.uniq.size == 2
      'isosceles'
    else
      'scalene'
    end
  end

  private

  def valid? # without sorting sides, more logic needed here, perhaps less readable?
    sides.min > 0 && # but it's also a private method which makes other code cleaner
    sides[0] + sides[1] > sides[2] &&
    sides[1] + sides[2] > sides[0] &&
    sides[0] + sides[2] > sides[1]
  end
end

### Solution from fellow LS student I really like (slightly altered for appearance):

class Triangle 
  def initialize(s1, s2, s3)
    @sides = [s1, s2, s3]

    if @sides.any? { |s| s <= 0 }
      raise ArgumentError, "All sides must be greater than zero"
    elsif @sides.sum <= @sides.max * 2
      raise ArgumentError, "Invalid side values" 
    end
  end

  def kind # this is genius
    ['equilateral', 'isosceles', 'scalene'][@sides.uniq.size - 1]
  end
end
