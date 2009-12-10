require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Set do

  [:eql?, :==].each do |method|

    describe "##{method}" do

      [
        [[], [], true],
        [[], [nil], false],
        [["A"], [], false],
        [["A"], ["A"], true],
        [["A"], ["B"], false],
        [["A", "B"], ["A"], false],
        [["A", "B", "C"], ["A", "B", "C"], true],
        [["C", "A", "B"], ["A", "B", "C"], true],
      ].each do |a, b, expected|

        describe "returns #{expected}" do

          before do
            @a = Hamster.set(*a)
            @b = Hamster.set(*b)
          end

          it "for #{a.inspect} and #{b.inspect}" do
            @a.send(method, @b).should == expected
          end

          it "for #{b.inspect} and #{a.inspect}" do
            @b.send(method, @a).should == expected
          end

        end

      end

    end

  end

end
