require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Set do

  describe "#eql?" do

    [
      [[], [], true],
      [["A"], [], false],
      [[], ["A"], false],
      [["A"], ["A"], true],
      [["A"], ["B"], false],
      [["A", "B"], ["A"], false],
      [["A"], ["A", "B"], false],
      [["A", "B", "C"], ["A", "B", "C"], true],
      [["C", "A", "B"], ["A", "B", "C"], true],
    ].each do |a, b, result|

      it "returns #{result} for #{a.inspect} and #{b.inspect}" do
        Hamster::Set[*a].eql?(Hamster::Set[*b]).should == result
      end

    end

  end

end
