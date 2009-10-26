module Hamster

  class List

    include Enumerable
    
    def cons(item)
      List.new(item, self)
    end

    def head
      @head
    end

    def tail
      @tail
    end
    
    def empty?
      size == 0
    end
    
    def size
    end
    
    def each
      self
    end

  end

end
