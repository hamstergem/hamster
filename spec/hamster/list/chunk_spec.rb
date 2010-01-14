require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  describe "#chunk" do

    it "is lazy" do
      pending do
        lambda { Hamster.stream { fail }.chunk(2) }.should_not raise_error
      end
    end

    [
      [[], []],
      [["A"], [Hamster.list("A")]],
      [["A", "B", "C"], [Hamster.list("A", "B"), Hamster.list("C")]],
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
