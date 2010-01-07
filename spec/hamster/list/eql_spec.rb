require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  [:eql?, :==].each do |method|

    describe "##{method}" do

      describe "doesn't run out of stack space on a really big" do

        it "stream" do
          @a = Hamster.interval(0, STACK_OVERFLOW_DEPTH)
          @b = Hamster.interval(0, STACK_OVERFLOW_DEPTH)
        end

        it "list" do
          @a = (0..STACK_OVERFLOW_DEPTH).reduce(Hamster.list) { |list, i| list.cons(i) }
          @b = (0..STACK_OVERFLOW_DEPTH).reduce(Hamster.list) { |list, i| list.cons(i) }
        end

        after do
          @a.send(method, @b)
        end

      end

      describe "returns false when comparing with" do

        before do
          @list = Hamster.list("A", "B", "C")
        end

        it "an array" do
          @list.send(method, ["A", "B", "C"]).should be_false
        end

        it "an aribtrary object" do
          @list.send(method, Object.new).should be_false
        end

      end

      [
        [[], [], true],
        [[], [nil], false],
        [["A"], [], false],
        [["A"], ["A"], true],
        [["A"], ["B"], false],
        [["A", "B"], ["A"], false],
        [["A", "B", "C"], ["A", "B", "C"], true],
        [["C", "A", "B"], ["A", "B", "C"], false],
      ].each do |a, b, expected|

        describe "returns #{expected.inspect}" do

          before do
            @a = Hamster.list(*a)
            @b = Hamster.list(*b)
          end

          it "for lists #{a.inspect} and #{b.inspect}" do
            @a.send(method, @b).should == expected
          end

          it "for lists #{b.inspect} and #{a.inspect}" do
            @b.send(method, @a).should == expected
          end

        end

      end

    end

  end

end
