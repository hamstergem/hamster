require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Hash do

  describe "#reduce" do

    describe "when empty" do

      before do
        @original = Hamster::Hash[]
        @result = @original.reduce("ABC") {}
      end

      it "returns the memo" do
        @result.should == "ABC"
      end

    end

    describe "when not empty" do

      before do
        @original = Hamster::Hash["A" => "aye", "B" => "bee", "C" => "see"]
      end

      describe "with a block" do

        before do
          @result = @original.reduce(0) { |memo, key, value| memo + 1 }
        end

        it "returns the final memo" do
          @result.should == 3
        end

      end

      describe "with no block" do

        before do
          @result = @original.reduce("ABC")
        end

        it "returns the memo" do
          @result.should == "ABC"
        end

      end

    end

  end

end
