=begin

Problem: create a custom set type

Rules:
  all elements of the set must be numbers
  don't use the built-in implementation of Set
    (until after solving this challenge)
  how it works internally doesn't matter
  must behave like a set of unique elements
  must be manipulatable in a few specific ways

classes/methods / algorithms:
  CustomSet class
    #initialize (#new)
      -optional argument: an array of 1 or more numbers (default val = [])
      -assign arg to instance var @elements_list
    #empty?
      -returns true or false depending on if custom set is empty
        -use Array#empty?
    #contains?
      -returns true or false depending on if set contains the argument
        -use Array#include?
    #subset?
      -requires a CustomSet object argument
      -returns true if calling set is a subset of the custom set argument
        -all elements from calling set must be found in set arg
          (#all?)
    #disjoint?(requires a custom set object argument)
      -returns false if the two sets share any elements, otherwise true
    #eql?(requires a custom set object argument)
      -returns true if all unique elements in one set are found in other set
        (or true if both sets are empty)
      -otherwise false
    #add(requires an integer arg)
      -inserts arg into calling set at the end, unless element already in set
      -returns self
      -testing with #assert_equal uses #==, so we have to define CustomSet#==
    #==(other_set)
      -elements_list == other_set.elements_list
    #intersection(requires a custom set object arg)
      -returns a new custom set with only the shared elements from the other two
        -#select all elements from first set which the 2nd set contains
        -CustomSet.new(return value of #select above)
    #difference(requires a custom set object arg)
      -returns a new custom set with only the elements from the calling set
        which are not found in the argument set
        -#reject all but the unique elements from the first set
          -use to construct new
    #union(requires a custom set obj arg)
      -returns a new custom set made up of all unique elements from both sets
        (merges the two and removes duplicates)
        -create empty new custom set
          -iterate through first set and add its elements to results set
          -iterate through 2nd set and #add its elements to results set
          -sorts elements list of results set and returns set
            (#add should avoid duplicates already)
      -requires a protected reader method to access @elements list of other set

=end

## My original solution: solved in 70 minutes, before time spent refactoring
# no rubocop complaints

class CustomSet
  def initialize(elements_list=[])
    @elements_list = elements_list.uniq # #uniq added after reviewing 'P'edac.
  end # need to avoid duplicates during construction, before calling #eql?

  def ==(other_set) # order does not matter, according to problem description
    eql?(other_set)
  end

  def empty?
    elements_list.empty?
  end

  def contains?(int)
    elements_list.include?(int)
  end

  def subset?(other_set)
    elements_list.all? { |element| other_set.contains?(element) }
  end

  def disjoint?(other_set)
    !elements_list.any? { |element| other_set.contains?(element) }
  end

  # LS PEDAC says #== should call #eql?, which implies my #eql? is incorrect.
  # I set this up to satisfy tests, but it only checked if both sets are empty,
  # or else that all the elements in the calling set are found in the arg set.
  # however, it seems that this should return false if there is any difference.
  # so instead, I will use the LS PEDAC suggestion for #==,
  # and replace #eql? with the previous contents of #== (to check for equality)
  def eql?(other_set)
    elements_list.sort == other_set.elements_list.sort # had to add #sort calls
    # old code:
    # if empty?
    #   other_set.empty?
    # else
    #   elements_list.all? { |element| other_set.contains?(element) }
    # end
  end

  def add(int)
    elements_list << int unless contains?(int)
    self
  end

  def intersection(other_set) # could be in one line but this is more readable
    shared_elements = elements_list.select { |el| other_set.contains?(el) }
    CustomSet.new(shared_elements)
  end

  def difference(other_set)
    uniq_elements = elements_list.reject { |el| other_set.contains?(el) }
    CustomSet.new(uniq_elements)
  end

  def union(other_set)
    # refactored solution:
    CustomSet.new((elements_list | other_set.elements_list).sort)

    # refactor attempt #1:
    # unified_set = CustomSet.new
    # [elements_list, other_set.elements_list].each do |set|
    #   set.each do |element|
    #     unified_set.add(element)
    #   end
    # end
    # unified_set.elements_list.sort!
    # unified_set

    # original solution:
    # unified_set = CustomSet.new
    # elements_list.each { |element| unified_set.add(element) }
    # other_set.elements_list.each { |element| unified_set.add(element) }
    # unified_set.elements_list.sort!
    # unified_set
  end

  protected

  attr_reader :elements_list
end
