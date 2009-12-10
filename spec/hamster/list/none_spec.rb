require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#none?" do

    describe "on a really big list" do

      before do
        @list = Hamster.interval(0, 100000)
      end

      it "doesn't run out of stack space" do
        @list.none? { false }
      end

    end

    describe "when empty" do

      before do
        @list = Hamster.list
      end

      it "with a block returns true" do
        @list.none? {}.should be_true
      end

      it "with no block returns true" do
        @list.none?.should be_true
      end

    end

    describe "when not empty" do

      describe "with a block" do

        before do
          @list = Hamster.list("A", "B", "C", nil)
        end

        ["A", "B", "C", nil].each do |value|

          it "returns false if the block ever returns true (#{value.inspect})" do
            @list.none? { |item| item == value }.should be_false
          end

        end

        it "returns true if the block always returns false" do
          @list.none? { |item| item == "D" }.should be_true
        end

      end

      describe "with no block" do

        it "returns false if any value is truthy" do
          Hamster.list(nil, false, true, "A").none?.should be_false
        end

        it "returns true if all values are falsey" do
          Hamster.list(nil, false).none?.should be_true
        end

      end

    end

  end

end
