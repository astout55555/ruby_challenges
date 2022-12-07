# Solved in 70 minutes

=begin

Problem:

inputs:
  -descriptor ('first'-'fifth', 'last', or 'teenth' -- case insensitive)
    -('teenth' means the 13-19th day of month)
  -day of the week (case insensitive)
  -month number (1-12, integer)
  -year (e.g. 2022, integer)
output: exact date for that year/month based on string description (or nil)

-define a Meetup class, which takes the month and year when instantiated
  -nothing is output when the Meetup object is created.
-must have a #day instance method
  -takes the descriptor and day of week as args
  -#day is what returns the exact date.
  -#day returns nil if no such date exists
    (fifth Monday e.g. may not occur in month)

Data/Algorithm:

init constant to store string days of week
  (such that index val == return of Date#wday)

#day
loop with day_of_month counter from 1 on
  until it can create a Date object with correct day_of_week

-create Date object based on result of helper method to determine numeric day
  (based on descriptor)
  -rescue Date::Error (invalid date) and return nil if cannot be created
-#find_day_of_month
  -increment by idx weeks if 'first' through 'fifth'
  -for 'teenth', increment by 7 days until (13..19).include?(day_of_month)
  -return day_of_month
  -for 'last'
    -in loop starting from 31 down, create date objects with that day
      -rescue errors and next
      -end loop and return day_of_month once correct day of week is found

=end

require 'date'

## my original solution: completed in 70 minutes

# triggers 3 rubocop complaints (4 with commenting increasing a line's length)
# rubocop:disable Layout/LineLength

# class Meetup
#   DAYS_OF_WEEK = ['sunday', 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday']

#   def initialize(year, month)
#     @year = year
#     @month = month
#   end

#   def day(day_of_week, descriptor)
#     day_of_month = 1
#     loop do
#       date = Date.civil(@year, @month, day_of_month)
#       break if date.wday == DAYS_OF_WEEK.index(day_of_week.downcase)
#       day_of_month += 1
#     end

#     day_of_month = adjust_for_descriptor(day_of_month, day_of_week, descriptor)

#     begin
#       Date.civil(@year, @month, day_of_month)
#     rescue Date::Error
#       nil
#     end
#   end

#   private

#   def adjust_for_descriptor(day_of_month, day_of_week, descriptor)
#     if descriptor.downcase == 'teenth'
#       day_of_month += 7 until (13..19).include?(day_of_month)
#     elsif descriptor.downcase == 'last'
#       day_of_month = 31
#       loop do
#         begin
#           date = Date.civil(@year, @month, day_of_month)
#         rescue Date::Error
#           day_of_month -= 1
#           next
#         end

#         break if date.wday == DAYS_OF_WEEK.index(day_of_week.downcase)
#         day_of_month -= 1
#       end
#     else
#       descriptors = ['first', 'second', 'third', 'fourth', 'fifth']
#       day_of_month += 7 * descriptors.index(descriptor.downcase)
#     end

#     day_of_month
#   end
# end

# rubocop:enable Layout/LineLength

## refactored solution, no rubocop errors:

class Meetup
  DAYS_OF_WEEK = ['sunday', 'monday', 'tuesday',
                  'wednesday', 'thursday', 'friday', 'saturday']

  def initialize(year, month)
    @year = year
    @month = month
  end

  def day(day_of_week, descriptor)
    day_of_week = day_of_week.downcase
    descriptor = descriptor.downcase

    day_of_month = find_day_of_month(day_of_week, descriptor)

    begin
      Date.civil(@year, @month, day_of_month)
    rescue Date::Error
      nil
    end
  end

  private

  def find_day_of_month(day_of_week, descriptor)
    day_of_month = find_first_in_month(day_of_week)

    if descriptor == 'teenth'
      day_of_month += 7 until (13..19).include?(day_of_month)
    elsif descriptor == 'last'
      day_of_month = find_last_in_month(day_of_week)
    else
      descriptors = ['first', 'second', 'third', 'fourth', 'fifth']
      day_of_month += 7 * descriptors.index(descriptor)
    end

    day_of_month
  end

  def find_first_in_month(day_of_week)
    day_of_month = 1
    loop do
      date = Date.civil(@year, @month, day_of_month)
      return day_of_month if date.wday == DAYS_OF_WEEK.index(day_of_week)
      day_of_month += 1
    end
  end

  def find_last_in_month(day_of_week)
    day_of_month = 32
    loop do
      day_of_month -= 1
      begin
        date = Date.civil(@year, @month, day_of_month)
      rescue Date::Error
        next
      end
      return day_of_month if date.wday == DAYS_OF_WEEK.index(day_of_week)
    end
  end
end

## LS Solution:

# starts by identifying first of possible days based on descriptor
class Meetup
  SCHEDULE_START_DAY = {
    'first' => 1,
    'second' => 8,
    'third' => 15,
    'fourth' => 22,
    'fifth' => 29,
    'teenth' => 13,
    'last' => nil # last is nil because there is no set first 'last' day
  }.freeze # nil avoids returning the first operand in the || statement below

  def initialize(year, month)
    @year = year
    @month = month
    @days_in_month = Date.civil(@year, @month, -1).day
  end # uses `-1` to find last day of month--very useful!

  def day(weekday, schedule)
    weekday = weekday.downcase # gets the downcasing out of the way up front
    schedule = schedule.downcase

    first_possible_day = first_day_to_search(schedule) # pulls from hash above
    last_possible_day = [first_possible_day + 6, @days_in_month].min
    # using #min with @days_in_month avoids overshooting end of month

    # #detect returns first element for which block returns a truthy value
    (first_possible_day..last_possible_day).detect do |day| # aliased as #find
      date = Date.civil(@year, @month, day)
      break date if day_of_week_is?(date, weekday)
    end # didn't know you could use break to interrupt iteration and return
  end

  private

  def first_day_to_search(schedule)
    SCHEDULE_START_DAY[schedule] || (@days_in_month - 6) # 'last' returns 2nd
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def day_of_week_is?(date, weekday)
    case weekday
    when 'monday'    then date.monday?
    when 'tuesday'   then date.tuesday?
    when 'wednesday' then date.wednesday?
    when 'thursday'  then date.thursday?
    when 'friday'    then date.friday?
    when 'saturday'  then date.saturday?
    when 'sunday'    then date.sunday?
    end
  end
end

## Nimish Tolasaria (LS student) had a really interesting solution which used #send:

class Meetup
  def initialize(year, month)
    @date = Date.civil(year, month)
  end

  def day(weekday, schedule)
    weekday = weekday.downcase.concat('?')
    send(schedule.downcase, weekday) 
  end # calls the appropriate private method with a 'monday?' formatted arg

  private

  def first(weekday)
    start_date = @date
    start_date += 1 while !start_date.send(weekday) # arg used to call #monday?
    start_date
  end

  def second(weekday)
    first(weekday) + 7
  end

  def third(weekday)
    first(weekday) + 14
  end

  def fourth(weekday)
    first(weekday) + 21
  end

  def fifth(weekday)
    possible_date = fourth(weekday) + 7 # using `+ 7` increments date by 7 days
    possible_date if possible_date.month == @date.month # did it roll to next?
  end # no error because date is not constructed with bad num, month rolls over

  def last(weekday)
    fifth(weekday) || fourth(weekday) # this is smart
  end

  def teenth(weekday)
    start_date = @date + 12
    start_date += 1 while !start_date.send(weekday)
    start_date
  end
end
