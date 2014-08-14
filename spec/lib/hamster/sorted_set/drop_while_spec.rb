require "spec_helper"
require "hamster/sorted_set"

describe Hamster::SortedSet do
  describe "#drop_while" do
    [
      [[], []],
      [["A"], []],
      [%w[A B C], ["C"]],
    ].each do |values, expected|

      describe "on #{values.inspect}" do
        before do
          @original = Hamster.sorted_set(*values)
        end

        describe "with a block" do
          before do
            @result = @original.drop_while { |item| item < "C" }
          end

          it "preserves the original" do
            @original.should eql(Hamster.sorted_set(*values))
          end

          it "returns #{expected.inspect}" do
            @result.should eql(Hamster.sorted_set(*expected))
          end
        end

        describe "without a block" do
          before do
            @result = @original.drop_while
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