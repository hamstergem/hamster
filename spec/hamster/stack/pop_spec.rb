require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Stack do

  describe "#pop" do

    [
      [["A", "B"], ["A"]],
      [["A", "B", "C"], ["A", "B"]],
    ].each do |values, expected|

      describe "on #{values.inspect}" do

        before do
          @original = Hamster.stack(*values)
          @result = @original.pop
        end

        it "preserves the original" do
          @original.should == Hamster.stack(*values)
        end

        it "returns #{expected.inspect}" do
          @result.should == Hamster.stack(*expected)
        end

      end

    end

    [
      [],
      ["A"],
    ].each do |values|

      describe "on #{values.inspect}" do

        before do
          @original = Hamster.stack(*values)
          @result = @original.pop
        end

        it "preserves the original" do
          @original.should == Hamster.stack(*values)
        end

        it "returns the empty stack" do
          @result.should equal(Hamster.stack)
        end

      end

    end

  end

end
