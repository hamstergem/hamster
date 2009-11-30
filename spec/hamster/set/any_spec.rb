require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Set do

  describe "#any?" do

    describe "when empty" do

      before do
        @set = Hamster::Set[]
      end

      it "with a block returns false" do
        @set.any? {}.should be_false
      end

      it "with no block returns false" do
        @set.any?.should be_false
      end

    end

    describe "when not empty" do

      describe "with a block" do

        before do
          @set = Hamster::Set["A", "B", "C", nil]
        end

        ["A", "B", "C", nil].each do |value|

          it "returns true if the block ever returns true (#{value.inspect})" do
            @set.any? { |item| item == value }.should be_true
          end

        end

        it "returns false if the block always returns false" do
          @set.any? { |item| item == "D" }.should be_false
        end

      end

      describe "with no block" do

        it "returns true if any value is truthy" do
          Hamster::Set[nil, false, true, "A"].any?.should be_true
        end

        it "returns false if all values are falsey" do
          Hamster::Set[nil, false].any?.should be_false
        end

      end

    end

  end

end
