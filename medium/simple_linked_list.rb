=begin

##Problem: write a simple linked list implementation
-each element in the list contains data and a next field pointing to the next element
-often used for LIFO stacks

2 classes, each with various instance methods:
  Element
    #datum
    #tail?
    #next

  SimpleLinkedList
    #size
    #empty?
    #push(integer)
    #peek
    #head
    #pop
    self.from_a(array--can be empty--or nil) (class method)
    #reverse
    #to_a

##Data:
  most SimpleLinkedList methods can be inherited by including the Enumerable module, except:
    -when constructed with #new, list starts empty
    #peek
      -returns the data from the first element in the collection/list
      -returns nil if collection is empty
    #head
      -returns the first element object in the list
      -returns nil if list is empty
    self.from_a(array or nil arg) (class method)
      -build list using an array to create its element objects
      -when passed nil or an empty array, creates an empty list
    #reverse
      -returns a new SimpleLinkedList object with the order of elements reversed
    #empty?
      -returns true or false based on whether @contents/@list is empty array
    #pop
      -removes first item from @list and returns its datum
    #to_a
      -returns @list
    #size
      -returns @list.size
  Element instance methods need to be custom methods
    -when constructed with #new, passed an arg which becomes its data
      -can be passed an optional 2nd arg which is the 'next' element it points to
    #datum
      -returns the data stored by the element object
    #tail?
      -returns true or false depending on whether it is the last element in list
    #next
      -returns next element (element its 'next' instance var points to)
      -returns nil if no element is next

Element objects are collaborators with the SimpleLinkedList object
  (the SimpleLinkedList object is a custom collection of Element objects)

Element objects are collaborators for each other
  (elements should have a @next instance var pointing to the next element in list)
  value of @next is return value of #next instance method (default is nil)

SimpleLinkedList object:
  -must have a definite order (a @contents instance var collaborator object which is an array of all its elements)
  -can use index of the elements to track these links

##Algorithms:

Element#tail?
  -should return true if #next returns nil, otherwise false

Element#next
  -can simply be a public reader method to reference @next

SimpleLinkedList#push(integer)
  -identify head of list, store in local var
  -create a new Element object using integer arg as its data
  -assign old head to the @next value of the new element
  -add new element to the @list array (at beginning--last in, first out)

@list is filled from from the left, and @next refers to the element to the left
  []
  [1]
  [2, 1]

  2 element @next == 1 element
  2 element is list head

=end

## My initial solution: solved in 118 minutes, no rubocop complaints

class Element
  attr_reader :datum

  def initialize(datum, next_element=nil)
    @datum = datum
    @next_element = next_element
  end

  def tail?
    !@next_element
  end

  def next
    @next_element
  end

  def next=(element)
    @next_element = element
  end
end

class SimpleLinkedList
  def initialize
    @list = []
  end

  def self.from_a(array)
    collection = SimpleLinkedList.new
    unless array.nil? || array.empty?
      array.reverse.each do |datum|
        collection.push(datum)
      end
    end
    collection
  end

  def reverse
    array = to_a
    SimpleLinkedList.from_a(array.reverse)
  end

  def peek
    return nil if @list.empty?
    @list.first.datum
  end

  def head
    return nil if @list.empty?
    @list.first
  end

  def push(datum)
    new_element = Element.new(datum, head)
    @list.unshift(new_element)
  end

  def to_a
    array = []

    @list.each do |element|
      array << element.datum
    end

    array
  end

  def pop
    @list.shift.datum
  end

  def empty?
    @list.empty?
  end

  def size
    @list.size
  end
end

## LS Solution:

class Element
  attr_reader :datum, :next
# imo @next should be renamed so it's not the same as the reader method name,
# otherwise you can't use #next within the class definition, have to use @next
  def initialize(datum, next_element = nil)
    @datum = datum
    @next = next_element
  end

  def tail?
    @next.nil? # clearer than mine
  end
end

class SimpleLinkedList # interesting choice not to use #initialize at all
  attr_reader :head # allows @head to be referenced and reassigned
# also provides #head reader method, without initializing @head to a value
# might be necessary if we couldn't use arrays as collaborator objects
  def size
    size = 0
    current_elem = @head # returns nil if @head hasn't been initialized yet
    while (current_elem) # otherwise, starts this loop at first element
      size += 1 # increments size as it moves through
      current_elem = current_elem.next # using element#next to locate linked el
    end
    size
  end

  def empty?
    @head.nil?
  end

  def push(datum)
    element = Element.new(datum, @head)
    @head = element
  end

  def peek
    @head.datum if @head # more concise--a failed `if` conditional returns nil
  end

  def pop
    datum = peek # so we can return @head.datum after reassigning @head.
    new_head = @head.next # once @head is reassigned, it's as if the prior
    @head = new_head # @head element is gone--nothing is tracking that value.
    datum
  end

  def self.from_a(array)
    array = [] if array.nil?

    list = SimpleLinkedList.new # I didn't know about #reverse_each,
    array.reverse_each { |datum| list.push(datum) } # that's useful!
    list
  end

  def to_a # order of array or reversed SimpleLinkedList is opposite original.
    array = []
    current_elem = head
    while !current_elem.nil? # they both just prepend elements to the new coll,
      array.push(current_elem.datum) # starts from the lefthand of the old coll
      current_elem = current_elem.next
    end
    array
  end

  def reverse # works the same here--arrays are ordered first to last added,
    list = SimpleLinkedList.new # while lists are ordered last added/first out
    current_elem = head # (to first added/last out).
    while !current_elem.nil?
      list.push(current_elem.datum)
      current_elem = current_elem.next
    end
    list
  end
end

## LS Student Brenno Kaneyasu had a different version of my solution:

class Element
  attr_accessor :next
  attr_reader :datum

  def initialize(*data) # unnecessarily complicated instance var assignment,
    @datum = data.first # could have just used 2 params, 2nd is default nil.
    @next = data.last if data.last.is_a?(Element)
  end

  def tail?
    @next.nil?
  end
end

class SimpleLinkedList
  def initialize
    @list = [] # based around the @list collaborator Array object, like mine.
  end

  def size # makes these methods much simpler
    @list.size
  end

  def empty?
    @list.empty?
  end

  def head # this is the main difference/advantage of their approach:
    @list.last # they set #head to the end of the array,
  end # so behavior of #push and #pop doesn't have to be reversed!

  def push(element)
    @list.push(Element.new(element)) # adds elements from the right,
    head.next = @list[-2] if @list.size > 1 # like normal for arrays.
  end # sets @next to the left (instead of to the right) in the @list array.

  def peek
    @list.empty? ? nil : head.datum
  end

  def pop
    @list.pop.datum
  end

  def to_a
    @list.reverse.map(&:datum) # nice and concise
  end

  def reverse
    SimpleLinkedList.from_a(to_a.reverse) # `self.to_a` could be clearer
  end

  def self.from_a(elements)
    list = SimpleLinkedList.new
    elements.reverse.each { |e| list.push(e) } unless
    elements.nil? || elements.empty? # oddly spaced part of unless conditional
    list
  end
end

## Similar but more polished version from LS student Chris Shen:

class Element
  attr_reader :datum, :next

  def initialize(obj, pointing_obj=nil)
    @datum, @next = obj, pointing_obj
  end

  def tail?
    self.next.nil? ? true : false
  end
end

class SimpleLinkedList
  attr_reader :elements

  def self.from_a(arr)
    return new if arr.nil? || arr.empty?
    arr.reverse.each_with_object(new) { |el, list| list.push(el) }
  end

  def initialize
    @elements = []
  end

  def size
    elements.size
  end

  def empty?
    elements.empty?
  end

  def push(obj) # useful to create Element with return of #head as 2nd arg
    elements << Element.new(obj, head) # adds elements from the right.
  end

  def peek
    empty? ? nil : head.datum
  end

  def head # head returns last element from array, like above
    elements.last
  end

  def pop
    elements.pop.datum
  end

  def to_a
    elements.map(&:datum).reverse
  end

  def reverse # using 2 different `self` references here is confusing though
    self.class.from_a(self.to_a.reverse)
  end
end
