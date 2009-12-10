require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  [:eql?, :==].each do |method|

    describe "on a really big list" do

      before do
        @a = Hamster.interval(0, 100000)
        @b = Hamster.interval(0, 100000)
      end

      it "doesn't run out of stack space" do
        pending do
          @a.eql?(@b)
        end
      end

    end


    describe "##{method}" do

      [
        [[], [], true],
        [["A"], [], false],
        [[], ["A"], false],
        [["A"], ["A"], true],
        [["A"], ["B"], false],
        [["A", "B"], ["A"], false],
        [["A"], ["A", "B"], false],
        [["A", "B", "C"], ["A", "B", "C"], true],
        [["C", "A", "B"], ["A", "B", "C"], false],
      ].each do |a, b, expected|

        describe "on #{a.inspect} and #{b.inspect}" do

          before do
            @a = Hamster.list(*a)
            @b = Hamster.list(*b)
          end

          it "returns #{expected}" do
            @a.send(method, @b).should == expected
          end

        end

      end

    end

  end

end
