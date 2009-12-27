require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  [:eql?, :==].each do |method|

    describe "##{method}" do

      describe "doesn't run out of stack space on a really big" do

        before do
          @interval_a = Hamster.interval(0, 10000)
          @interval_b = Hamster.interval(0, 10000)
        end

        it "interval" do
          @a = @interval_a
          @b = @interval_b
        end

        it "list" do
          @a = @interval_a.reduce(Hamster.list) { |list, i| list.cons(i) }
          @b = @interval_b.reduce(Hamster.list) { |list, i| list.cons(i) }
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
