require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Hash do

  describe "#all?" do

    describe "with a block" do

      before do
        @hash = Hamster::Hash["A" => "aye", "B" => "bee", "C" => "see"]
      end

      it "returns true if the block always returns true" do
        @hash.all? { |item| true }.should be_true
      end

      it "returns false if the block ever returns false" do
        @hash.all? { |key, value| key == "D" || value == "dee" }.should be_false
      end

    end

    describe "with no block" do

      [nil, false].each do |value|

        it "returns true if all keys and values are non-#{value.inspect}" do
          Hamster::Hash[!value => !value].all?.should be_true
        end

        it "returns false if any key or value is #{value.inspect}" do
          Hamster::Hash[value => value, true => true, "A" => "aye"].all?.should be_false
        end

      end

    end

  end

end
