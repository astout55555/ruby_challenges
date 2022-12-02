# Solved in 39 minutes

=begin

Problem: write a program which can generate the lyrics of the 99 Bottles of Beer song
  -need to create a BeerSong class
  -needs 3 class methods
    #verse
      input: integer (verse number, counting from 99 to 0 to match # of beers left)
      output: the appropriate verse string
    #verses
      input: 2 integers--the starting and ending verse
      output: all verses between/including start and end verse
    #lyrics
      input: none
      output: entire song lyrics

Data/Algorithm:

1. generate a verse with interpolated number of beers left
  -concatenate 2 halves of the verse, changing value of beers left and bottles
  -if number is 2, 1, or 0, produce unique verses
2. for #verses, use #verse from start..end
  -return concatenated string of all verses, with newlines between
3. for #lyrics, use #verses method from 99 downto 0

=end

class BeerSong
  def self.verse(beers)
    case beers
    when 2
      antipenultimate_verse = <<~VERSE
        2 bottles of beer on the wall, 2 bottles of beer.
        Take one down and pass it around, 1 bottle of beer on the wall.
      VERSE
      antipenultimate_verse
    when 1
      penultimate_verse = <<~VERSE
        1 bottle of beer on the wall, 1 bottle of beer.
        Take it down and pass it around, no more bottles of beer on the wall.
      VERSE
      penultimate_verse
    when 0
      final_verse = <<~VERSE
        No more bottles of beer on the wall, no more bottles of beer.
        Go to the store and buy some more, 99 bottles of beer on the wall.
      VERSE
      final_verse
    else
      verse = <<~VERSE
        #{beers} bottles of beer on the wall, #{beers} bottles of beer.
        Take one down and pass it around, #{beers - 1} bottles of beer on the wall.
      VERSE
      verse
    end
  end

  def self.verses(starting, ending)
    verses = ''
    starting.downto(ending) do |beers|
      verses += self.verse(beers)
      verses += "\n" unless beers == ending
    end
    verses
  end

  def self.lyrics
    self.verses(99, 0)
  end
end

# LS Solution:

class Verse # separate Verse class allows us to just create Verse objects as needed
  attr_reader :bottles

  def initialize(bottles)
    @bottles = bottles
  end

  def single_verse
    case bottles
    when 0
      zero_bottle_verse
    when 1
      single_bottle_verse
    when 2
      two_bottle_verse
    else
      default_verse
    end
  end

  private # separates versions from logic above to keep above code easier to read

  def default_verse
    "#{bottles} bottles of beer on the wall, #{bottles}" +
    " bottles of beer.\nTake one down and pass it around, " +
    "#{bottles-1} bottles of beer on the wall.\n"
  end

  def two_bottle_verse
    "2 bottles of beer on the wall, 2 bottles of beer.\n" +
    "Take one down and pass it around, 1 bottle of beer " +
    "on the wall.\n"
  end

  def single_bottle_verse
    "1 bottle of beer on the wall, 1 bottle of beer.\n" +
    "Take it down and pass it around, no more bottles of beer " +
    "on the wall.\n"
  end

  def zero_bottle_verse
    "No more bottles of beer on the wall, no more bottles " +
    "of beer.\nGo to the store and buy some more, 99 bottles " +
    "of beer on the wall.\n"
  end
end

class BeerSong
  def self.verse(number)
    Verse.new(number).single_verse
  end

  def self.verses(start, stop)
    current_verse = start
    result = [] # collect result of Verse#single_verse calls on Verse objects

    while current_verse >= stop
      result << "#{verse(current_verse)}"
      current_verse -= 1
    end

    result.join("\n") # joining with newline is cleaner than conditionally adding "\n"
  end

  def self.lyrics
    verses(99, 0)
  end
end
