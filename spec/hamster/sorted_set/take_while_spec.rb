require "spec_helper"
require "hamster/sorted_set"

describe Hamster::SortedSet do
  describe "#take_while" do
    [
      [[], []],
      [["A"], ["A"]],
      [%w[A B C], %w[A B]],
    ].each do |values, expected|

      describe "on #{values.inspect}" do
        before do
          @original = Hamster.sorted_set(*values)
          @result = @original.take_while { |item| item < "C" }
        end

        describe "with a block" do
          it "returns #{expected.inspect}" do
            @result.should eql(Hamster.sorted_set(*expected))
          end

          it "preserves the original" do
            @original.should eql(Hamster.sorted_set(*values))
          end
        end

        describe "without a block" do
          before do
            @result = @original.take_while
          end

          it "returns an Enumerator" do
            @result.class.should be(Enumerator)
            @result.each { |item| item < "C" }.should eql(Hamster.sorted_set(*expected))
          end
        end
      end
    end
  end
end
