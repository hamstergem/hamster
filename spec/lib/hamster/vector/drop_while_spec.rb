require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  describe "#drop_while" do
    [
      [[], []],
      [["A"], []],
      [%w[A B C], ["C"]],
    ].each do |values, expected|

      describe "on #{values.inspect}" do
        before do
          @original = Hamster.vector(*values)
        end

        describe "with a block" do
          before do
            @result = @original.drop_while { |item| item < "C" }
          end

          it "preserves the original" do
            @original.should eql(Hamster.vector(*values))
          end

          it "returns #{expected.inspect}" do
            @result.should eql(Hamster.vector(*expected))
          end
        end

        describe "without a block" do
          before do
            @result = @original.drop_while
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