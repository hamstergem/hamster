module Hamster

  class List

    def initialize(head = nil, tail = self)
      @head = head
      @tail = tail
    end

    # Returns <tt>true</tt> if the list contains no items.
    def empty?
      @tail.equal?(self)
    end

    # Returns the number of items in the list.
    def size
      if empty?
        0
      else
        @tail.size + 1
      end
    end

    # Returns the first item.
    def head
      @head
    end

    # Returns a copy of <tt>self</tt> without the first item.
    def tail
      @tail
    end

    # Returns a copy of <tt>self</tt> with it as the head.
    def cons(item)
      self.class.new(item, self)
    end

    # Calls <tt>block</tt> once for each item in the list, passing the item as the only parameter.
    # Returns <tt>self</tt>
    def each
      block_given? or return enum_for(__method__)
      unless empty?
        yield(@head)
        @tail.each { |item| yield(item) }
      end
      self
    end

    # Returns <tt>true</tt> if . <tt>eql?</tt> is synonymous with <tt>==</tt>
    def eql?(other)
      return true if other.equal?(self)
      return false unless other.is_a?(self.class)
      return true if other.empty? && empty?
      return other.head == head && other.tail.eql?(tail)
    end
    alias :== :eql?

    # Returns <tt>self</tt>
    def dup
      self
    end
    alias :clone :dup

    def map
      if empty?
        self
      else
        @tail.map { |item| yield(item) }.cons(yield(@head))
      end
    end

    def reduce(memo)
      if empty?
        memo
      else
        @tail.reduce(yield(memo, @head)) { |memo, item| yield(memo, item) }
      end
    end

    private

    def method_missing(name, *args, &block)
      if name.to_s =~ /^c([ad]+)r$/
        accessor($1)
      else
        super
      end
    end

    # Perform compositions of <tt>car</tt> and <tt>cdr</tt> operations. Their names consist of a 'c', followed by at
    # least one 'a' or 'd', and finally an 'r'. The series of 'a's and 'd's in each function's name is chosen to
    # identify the series of car and cdr operations that is performed by the function. The order in which the 'a's and
    # 'd's appear is the inverse of the order in which the corresponding operations are performed.
    def accessor(sequence)
      sequence.split(//).reverse!.inject(self) do |memo, char|
        case char
        when "a" then memo.head
        when "d" then memo.tail
        end
      end
    end

  end

end
