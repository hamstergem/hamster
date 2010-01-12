require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  describe "#tails" do

    [
      [[], [[]]],
      [["A"], [["A"], []]],
      [["A", "B", "C"], [["A", "B", "C"], ["B", "C"], ["C"], []]],
    ].each do |values, expected|

      expected = expected.map { |x| Hamster.list(*x) }

      describe "on #{values.inspect}" do

        before do
          @original = Hamster.list(*values)
          @result = @original.tails
        end

        it "preserves the original" do
          @original.should == Hamster.list(*values)
        end

        it "returns #{expected.inspect}" do
          @result.should == Hamster.list(*expected)
        end

      end

    end

  end

end
