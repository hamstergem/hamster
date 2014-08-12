require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  describe "#take" do
    [
      [[], 10, []],
      [["A"], 10, ["A"]],
      [%w[A B C], 0, []],
      [%w[A B C], 2, %w[A B]],
    ].each do |values, number, expected|

      describe "#{number} from #{values.inspect}" do
        before do
          @original = Hamster.vector(*values)
          @result = @original.take(number)
        end

        it "preserves the original" do
          @original.should eql(Hamster.vector(*values))
        end

        it "returns #{expected.inspect}" do
          @result.should eql(Hamster.vector(*expected))
        end
      end
    end
  end
end