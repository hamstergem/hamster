require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Hash do

  describe "#any?" do

    describe "when empty" do

      before do
        @hash = Hamster::Hash[]
      end

      it "with a block returns false" do
        @hash.any? {}.should be_false
      end

      it "with no block returns false" do
        @hash.any?.should be_false
      end

    end

    describe "when not empty" do

      before do
        @hash = Hamster::Hash["A" => "aye", "B" => "bee", "C" => "see", nil => "NIL"]
      end

      describe "with a block" do

        [
          ["A", "aye"],
          ["B", "bee"],
          ["C", "see"],
          [nil, "NIL"],
        ].each do |pair|

          it "returns true if the block ever returns true (#{pair.inspect})" do
            @hash.any? { |key, value| key == pair.first && value == pair.last }.should be_true
          end

          it "returns false if the block always returns false" do
            @hash.any? { |key, value| key == "D" && value == "dee" }.should be_false
          end

        end

      end

      describe "with no block" do

        it "returns true" do
          @hash.any?.should be_true
        end

      end

    end

  end

end
