require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Hash do

  describe "#any?" do

    describe "with a block" do

      before do
        @hash = Hamster::Hash["A" => "aye", "B" => "bee", "C" => "see", nil => "NIL"]
      end

      [
        ["A", "aye"],
        ["B", "bee"],
        ["C", "see"],
        [nil, "NIL"],
      ].each do |pair|

        it "returns true if the block ever returns true (#{pair.inspect})" do
          @hash.any? { |key, value| key == pair.first && value == pair.last }.should be_true
        end

      end

      it "returns false if the block always returns false" do
        @hash.any? { |key, value| key == "D" && value == "dee" }.should be_false
      end

    end

    describe "with no block" do

      [nil, false].each do |value|

        it "returns true if any value is non-#{value.inspect}" do
          Hamster::Hash[value => value, true => true, "A" => "aye"].any?.should be_true
        end

        it "returns false if all values are #{value.inspect}" do
          Hamster::Hash[value => value, value => value].any?.should be_false
        end

      end

    end

  end

end
