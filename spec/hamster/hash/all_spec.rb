require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Hash do

  describe "#all?" do

    describe "when empty" do

      before do
        @hash = Hamster.hash
      end

      it "with a block returns true" do
        @hash.all? {}.should be_true
      end

      it "with no block returns true" do
        @hash.all?.should be_true
      end

    end

    describe "when not empty" do

      before do
        @hash = Hamster.hash("A" => "aye", "B" => "bee", "C" => "see")
      end

      describe "with a block" do

        it "returns true if the block always returns true" do
          @hash.all? { |item| true }.should be_true
        end

        it "returns false if the block ever returns false" do
          @hash.all? { |key, value| key == "D" || value == "dee" }.should be_false
        end

      end

      describe "with no block" do

        it "returns true" do
          @hash.all?.should be_true
        end

      end

    end

  end

end
