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

## original solution: completed in 70 minutes

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
    day_of_month = find_day_of_month(day_of_week, descriptor)

    begin
      Date.civil(@year, @month, day_of_month)
    rescue Date::Error
      nil
    end
  end

  private

  def find_day_of_month(day_of_week, descriptor)
    day_of_month = find_first_day_in_month(day_of_week.downcase)

    if descriptor.downcase == 'teenth'
      day_of_month += 7 until (13..19).include?(day_of_month)
    elsif descriptor.downcase == 'last'
      day_of_month = find_last_day_in_month(day_of_week.downcase)
    else
      descriptors = ['first', 'second', 'third', 'fourth', 'fifth']
      day_of_month += 7 * descriptors.index(descriptor.downcase)
    end

    day_of_month
  end

  def find_first_day_in_month(day_of_week)
    day_of_month = 1
    loop do
      date = Date.civil(@year, @month, day_of_month)
      return day_of_month if date.wday == DAYS_OF_WEEK.index(day_of_week)
      day_of_month += 1
    end
  end

  def find_last_day_in_month(day_of_week)
    day_of_month = 32
    loop do
      day_of_month -= 1
      begin
        date = Date.civil(@year, @month, day_of_month)
        return day_of_month if date.wday == DAYS_OF_WEEK.index(day_of_week)
      rescue Date::Error
        next # useless, but avoids rubocop complaining about suppressed error
      end
    end
  end
end
