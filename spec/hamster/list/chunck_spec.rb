require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  describe "#chunk" do

    [
      [[], []],
      [["A"], [Hamster.list("A", nil)]],
      [["A", "B", "C"], [Hamster.list("A", "B"), Hamster.list("C", nil)]],
    ].each do |values, expected|

      describe "on #{values.inspect}" do

        before do
          @original = Hamster.list(*values)
          pending do
            @result = @original.chunk(2)
          end
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
