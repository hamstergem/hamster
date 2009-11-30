require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Hash do

  describe "#none?" do

    describe "when empty" do

      before do
        @hash = Hamster::Hash[]
      end

      it "with a block returns true" do
        @hash.none? {}.should be_true
      end

      it "with no block returns true" do
        @hash.none?.should be_true
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

          it "returns false if the block ever returns true (#{pair.inspect})" do
            @hash.none? { |key, value| key == pair.first && value == pair.last }.should be_false
          end

          it "returns true if the block always returns false" do
            @hash.none? { |key, value| key == "D" && value == "dee" }.should be_true
          end

        end

      end

      describe "with no block" do

        it "returns false" do
          @hash.none?.should be_false
        end

      end

    end

  end

end
