require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Stack do

  [:eql?, :==].each do |method|

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
      ].each do |a, b, result|

        describe "on #{a.inspect} and #{b.inspect}" do

          a = Hamster.stack(*a)
          b = Hamster.stack(*b)

          it "returns #{result}" do
            a.send(method, b).should == result
          end

        end

      end

    end

  end

end
