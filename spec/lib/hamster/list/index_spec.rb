require "spec_helper"
require "hamster/list"

describe Hamster::List do
  describe "#index" do
    context "on a really big list" do
      it "doesn't run out of stack" do
        -> { Hamster.interval(0, STACK_OVERFLOW_DEPTH).index(nil) }.should_not raise_error
      end
    end

    [
      [[], "A", nil],
      [[], nil, nil],
      [["A"], "A", 0],
      [["A"], "B", nil],
      [["A"], nil, nil],
      [["A", "B", nil], "A", 0],
      [["A", "B", nil], "B", 1],
      [["A", "B", nil], nil, 2],
      [["A", "B", nil], "C", nil],
      [[2], 2, 0],
      # [[2], 2.0, 0], # Doesn't work in JRuby, look at https://github.com/jruby/jruby/issues/2902.
                       # Consider using block for comparison with type cast.
      [[2.0], 2.0, 0],
      [[2.0], 2, 0],
    ].each do |values, item, expected|
      context "looking for #{item.inspect} in #{values.inspect}" do
        it "returns #{expected.inspect}" do
          Hamster.list(*values).index(item).should == expected
        end
      end
    end

    [
      [[], "A", nil],
      [[], nil, nil],
      [["A"], "A", 0],
      [["A"], "B", nil],
      [["A"], nil, nil],
      [["A", "B", nil], "A", 0],
      [["A", "B", nil], "B", 1],
      [["A", "B", nil], nil, 2],
      [["A", "B", nil], "C", nil],
      [[2], 2, 0],
      [[2], 2.0, 0],
      [[2.0], 2.0, 0],
      [[2.0], 2, 0],
    ].each do |values, item, expected|
      context "looking for #{item.inspect} in #{values.inspect} by block" do
        it "returns #{expected.inspect}" do
          Hamster.list(*values).index { |x| x == item }.should == expected
        end
      end
    end
  end
end