require "spec_helper"
require "hamster/list"
require "hamster/set"

describe Hamster::List do
  describe "#to_set" do

    [
      [],
      ["A"],
      %w[A B C],
    ].each do |values|

      describe "on #{values.inspect}" do

        before do
          original = Hamster.list(*values)
          @result = original.to_set
        end

        it "returns a set with the same values" do
          @result.should == Hamster.set(*values)
        end
      end
    end
  end
end