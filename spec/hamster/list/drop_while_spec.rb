require "spec_helper"
require "hamster/list"

describe Hamster::List do
  describe "#drop_while" do
    it "is lazy" do
      -> { Hamster.stream { fail }.drop_while { false } }.should_not raise_error
    end

    [
      [[], []],
      [["A"], []],
      [%w[A B C], ["C"]],
    ].each do |values, expected|

      describe "on #{values.inspect}" do
        before do
          @original = Hamster.list(*values)
        end

        describe "with a block" do
          before do
            @result = @original.drop_while { |item| item < "C" }
          end

          it "preserves the original" do
            @original.should eql(Hamster.list(*values))
          end

          it "returns #{expected.inspect}" do
            @result.should eql(Hamster.list(*expected))
          end
        end

        describe "without a block" do
          before do
            @result = @original.drop_while
          end

          it "returns an Enumerator" do
            @result.class.should be(Enumerator)
            @result.each { false }.should eql(@original)
          end
        end
      end
    end
  end
end