require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Set do

  describe "#none?" do

    describe "when empty" do

      before do
        @set = Hamster::Set[]
      end

      it "with a block returns true" do
        @set.none? {}.should be_true
      end

      it "with no block returns true" do
        @set.none?.should be_true
      end

    end

    describe "when not empty" do

      describe "with a block" do

        describe "when not empty" do

          before do
            @set = Hamster::Set["A", "B", "C", nil]
          end

          ["A", "B", "C", nil].each do |value|

            it "returns false if the block ever returns false (#{value.inspect})" do
              @set.none? { |item| item == value }.should be_false
            end

          end

          it "returns true if the block always returns false" do
            @set.none? { |item| item == "D" }.should be_true
          end

        end

      end

      describe "with no block" do

        it "returns false if any value is truthy" do
          Hamster::Set[nil, false, true, "A"].none?.should be_false
        end

        it "returns true if all values are falsey" do
          Hamster::Set[nil, false].none?.should be_true
        end

      end

    end

  end

end
