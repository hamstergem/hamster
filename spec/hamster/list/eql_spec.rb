require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  [:eql?, :==].each do |method|

    describe "##{method}" do

      it "returns true for the empty list" do
        Hamster.list.should eql(Hamster.list)
      end

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

        it "returns #{result} for #{a.inspect} and #{b.inspect}" do
          Hamster.list(*a).send(method, Hamster.list(*b)).should == result
        end

      end

    end

  end

end
