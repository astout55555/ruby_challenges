# Solved in 42 minutes

=begin

Problem: create a clock independent of Date
  -can add/subtract integer representing minutes to/from Clock object
    (clock object + 3 returns new clock object with time 3 minutes later)
    (#+ and #- will need to be Clock instance methods)
    total clock time needs to wrap around forwards and backwards, past midnights
      -can use total time instance var to track, find remainder if < 0 or >= 24hrs
  -two clocks with the same time should be equal to each other
    (#== will need to be an instance method that compares values of clock times)
  -Clock class should have a class method #at which is used to instantiate
    -pass #at an integer arg representing hours
    -it returns a Clock object at that time
      (e.g. Clock.at(8) returns clock object with time of '08:00')
    -can also pass optional 2nd integer arg to #at, representing minutes
      (e.g. Clock.at(8, 30) returns clock object with time of '08:30')
  -Clock objects can be converted to string representation of time with #to_s
    (may be best to give clock objects an instance var with total minutes)
    (time returned by #to_s is in 24hr format, which makes converting a total easier)
  
Rules:
  -no using Date or Time functionality

Data/Algorithm:
  #at
    -take hours and optional minutes arg, convert to total time
    -instantiate and return new clock object with total time saved as instance var
  #initialize
    -only pass total time, don't save hours and minutes
      (otherwise hours and minutes will need to be recalculated every time @time changes)
  #+ and #-
    -find total of @time +/- int arg, use to return new clock object with #new
  #to_s
    -assign hours, minutes to divmod of time by 60
    -interpolate and return string with hours (#rjust with 0s) and minutes

=end

class Clock
  def self.at(hours, minutes=0)
    time = ((hours * 60) + minutes) % (24 * 60) # remainder within range of 0...1440
    Clock.new(time) # Clock objects are never created with bad @time values when using #at
  end # alternative: if time < 0, time += 1440 until > 0; if >= 1440, -= 1440 until < 1440

  def initialize(time)
    @time = time
  end

  def +(minutes)
    new_time = @time + minutes
    hours, minutes = new_time.divmod(60)
    Clock.at(hours, minutes)
  end

  def -(minutes)
    new_time = @time - minutes
    hours, minutes = new_time.divmod(60)
    Clock.at(hours, minutes)
  end

  def ==(other_clock)
    self.time == other_clock.time
  end

  def to_s
    # convert @time to '23:59' string format 
    hours, minutes = @time.divmod(60).map(&:to_s)
    "#{hours.rjust(2, '0')}:#{minutes.rjust(2, '0')}"
  end

  protected

  attr_reader :time
end

# LS Solution: 53 lines of code (17 more than my original solution at 36)

class Clock
  attr_reader :hour, :minute # could be useful to allow public reference to hour/minute

  ONE_DAY = 24 * 60 # used several times throughout this solution, so a constant is helpful

  def initialize(hour, minute) # constructs Clock object with @hour and @minute, not @time
    @hour = hour # I ended up having to calculate hours from @time in #+ and #- anyway.
    @minute = minute # using hours/minutes instead does require that different calculations
  end # have to be made in #+ and #-, so it's not necessarily more concise in that way.

  def self.at(hour, minute=0)
    new(hour, minute) # can call #new within class method without explicit class name
  end

  def +(add_minutes)
    minutes_since_midnight = compute_minutes_since_midnight + add_minutes
    while minutes_since_midnight >= ONE_DAY
      minutes_since_midnight -= ONE_DAY
    end

    compute_time_from(minutes_since_midnight)
  end

  def -(sub_minutes)
    minutes_since_midnight = compute_minutes_since_midnight - sub_minutes
    while minutes_since_midnight < 0
      minutes_since_midnight += ONE_DAY
    end

    compute_time_from(minutes_since_midnight)
  end

  def ==(other_time) # compares hour and minute separately, instead of @time
    hour == other_time.hour && minute == other_time.minute
  end

  def to_s
    format('%02d:%02d', hour, minute); # #format is more concise than using #rjust, here,
  end # in part because we can reference @hour and @minute with the above setup.

  private

  def compute_minutes_since_midnight
    total_minutes = 60 * hour + minute
    total_minutes % ONE_DAY
  end

  def compute_time_from(minutes_since_midnight)
    hours, minutes = minutes_since_midnight.divmod(60)
    hours %= 24 # without total @time var, needs to be computed in several steps,
    self.class.new(hours, minutes) # but this is also because the LS author prefers to
  end # never use the % operator when negative numbers are a possibility, because the
end # % operator doesn't always function the same between languages with negative numbers.
