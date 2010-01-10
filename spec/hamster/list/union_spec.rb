require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  [:union, :|].each do |method|

    describe "#union" do

      describe "doesn't run out of stack space on a really big" do

        it "stream" do
          @a = @b = Hamster.interval(0, STACK_OVERFLOW_DEPTH)
        end

        it "list" do
          @a = @b = (0...STACK_OVERFLOW_DEPTH).reduce(Hamster.list) { |list, i| list.cons(i) }
        end

        after do
          @a.send(method, @b)
        end

      end

      it "is lazy" do
        count = 0
        a = Hamster.stream { count += 1 }
        b = Hamster.stream { count += 1 }
        result = a.send(method, b)
        count.should <= 2
      end

      [
        [[], [], []],
        [["A"], [], ["A"]],
        [["A", "B", "C"], [], ["A", "B", "C"]],
      ].each do |a, b, expected|

        describe "returns #{expected.inspect}" do

          before do
            @a = Hamster.list(*a)
            @b = Hamster.list(*b)
          end

          it "for #{a.inspect} and #{b.inspect}"  do
            @result = @a.send(method, @b)
          end

          it "for #{b.inspect} and #{a.inspect}"  do
            @result = @b.send(method, @a)
          end

          after  do
            @result.should == Hamster.list(*expected)
          end

        end

      end

    end

  end

end
