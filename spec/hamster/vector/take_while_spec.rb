require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  describe "#take_while" do
    [
      [[], []],
      [["A"], ["A"]],
      [%w[A B C], %w[A B]],
    ].each do |values, expected|

      describe "on #{values.inspect}" do
        before do
          @original = Hamster.vector(*values)
          @result = @original.take_while { |item| item < "C" }
        end

        describe "with a block" do
          it "returns #{expected.inspect}" do
            @result.should eql(Hamster.vector(*expected))
          end

          it "preserves the original" do
            @original.should eql(Hamster.vector(*values))
          end
        end

        describe "without a block" do
          before do
            @result = @original.take_while
          end

          it "returns an Enumerator" do
            @result.class.should be(Enumerator)
            @result.each { |item| item < "C" }.should eql(Hamster.vector(*expected))
          end
        end
      end
    end
  end
end
