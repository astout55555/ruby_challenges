=begin

Overall Problem:
write a program which can calculate the "Hamming distance" between 2 DNA strands
  -details aside, hamming distance is number of different characters between 2 strings
    -compared based on the length they have in common (based on the shorter string)

Examples/Tests:
  -provided by LS, copied to a testing file
  -show that I need to create a DNA class with a #hamming_distance instance method

#hamming_distance problem:
  -define #hamming_distance such that it can be called on a DNA object
  input: passed a string arg (can be empty) representing DNA strand to compare against
  output: integer, number of differences between first x chars of each strand
    where x is the length of the shorter strand
  -must not mutate original strand

Algorithm:

#initialize should assign string arg to @strand instance var
in #hamming_distance
  iterate through @strand's chars with index
  compare each char with char from same index of other strand
  increase hamming_distance counter by 1 whenever a difference found
  return hamming_distance once index is min size - 1

=end

class DNA
  def initialize(strand)
    @strand = strand
  end

  def hamming_distance(other_strand)
    min_length = [@strand, other_strand].map(&:size).min
    hamming_distance = 0

    @strand.chars.each_with_index do |_, idx|
      hamming_distance += 1 if @strand[idx] != other_strand[idx]
      return hamming_distance if idx >= min_length - 1
    end

    hamming_distance # needed in case @strand == ''
  end
end

### LS Solution:

class DNA
  def initialize(strand)
    @strand = strand
  end

  def hamming_distance(comparison) # finding which is shorter makes the rest easier
    shorter = @strand.length < comparison.length ? @strand : comparison
    differences = 0

    shorter.length.times do |index| # good reminder you can use a block param with #times
      differences += 1 unless @strand[index] == comparison[index]
    end # don't need explicit return here because we're iterating over shorter strand

    differences
  end
end
