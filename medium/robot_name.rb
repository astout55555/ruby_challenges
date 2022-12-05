# Solved in 40 minutes

=begin

Problem:
  -define a Robot class which generates a random name following the pattern when instantiated
  -must match regex like so: /^[A-Z]{2}\d{3}$/ (e.g. RX837)
  -name must be random, but also not allowed to be duplicates
  -robot objects must have a #reset instance method, which sets a new random name
Notes:
  -tests set the seed for the pseudo-random number generator to ensure deterministic result
    (that way tests can't accidentally fail)
    (this also allows the last test to ensure duplicate names aren't allowed)

Data/Algorithm:
  -use class variable (array) to contain all robot names generated
    -test against this with helper method to avoid duplicates
#set_random_name
  -create new Random object to generate letters/numbers
  -in loop,
    -init empty string name var
      -generate random number from 65-90 (ordinal numbers for 'A' to 'Z')
        -convert to letter with Integer#chr
        -push to name var
      -generate another letter in this way
      -generate 3 random integers, convert to strings and push to name (0-9)
    -break from loop unless name is not duplicate (use helper method)
  -push concatenated name string into robot_names class var
  -return name
#initialize
  -init @name to return of #set_random_name
#name_taken?
  return true or false based on if @@robot_names includes passed arg

=end

class Robot
  @@robot_names = []

  attr_reader :name

  def initialize
    @name = set_random_name
  end

  def reset
    @@robot_names.delete(@name)
    @name = set_random_name
  end

  private

  def set_random_name
    new_name = ''

    loop do
      2.times { new_name << rand(65..90).chr } # random letter 'A' to 'Z' using ords
      3.times { new_name << rand(10).to_s }
      
      break unless name_taken?(new_name)
      new_name = ''
    end

    @@robot_names << new_name # add name to class var whenever generated
    new_name
  end

  def name_taken?(new_name)
    @@robot_names.include?(new_name)
  end
end

# LS Solution:

class Robot
  @@names = []

  def name # I don't really like how #name generates the @name value, actually
    return @name if @name # it looks like a reader method but with this setup,
    @name = generate_name while @@names.include?(@name) || @name.nil?
    @@names << @name # the robot doesn't actually have a name at construction,
    @name # not until you call #name. I think that's counter-intuitive
  end

  def reset # this was an important bit, not tested, but which could be:
    @@names.delete(@name) # I incorporated name deletion into my own #reset above.
    @name = nil # counter-intuitive, leaves robot with no name unless #name is called again
  end

  private

  def generate_name # imo name generation is the more natural place to test for validity 
    name = ''
    2.times { name << rand(65..90).chr }
    3.times { name << rand(0..9).to_s }
    name
  end
end
