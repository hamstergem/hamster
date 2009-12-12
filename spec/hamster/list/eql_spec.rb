require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  [:eql?, :==].each do |method|

    describe "##{method}" do

      describe "on a really big list" do

        before do
          @a = Hamster.interval(0, 10000)
          @b = Hamster.interval(0, 10000)
        end

        it "doesn't run out of stack space" do
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

        describe "returns #{expected}" do

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
