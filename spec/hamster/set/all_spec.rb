require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/set'

describe Hamster::Set do

  describe "#all?" do

    describe "when empty" do

      before do
        @set = Hamster.set
      end

      it "with a block returns true" do
        @set.all? {}.should == true
      end

      it "with no block returns true" do
        @set.all?.should == true
      end

    end

    describe "when not empty" do

      describe "with a block" do

        before do
          @set = Hamster.set("A", "B", "C")
        end

        it "returns true if the block always returns true" do
          @set.all? { |item| true }.should == true
        end

        it "returns false if the block ever returns false" do
          @set.all? { |item| item == "D" }.should == false
        end

      end

      describe "with no block" do

        it "returns true if all values are truthy" do
          Hamster.set(true, "A").all?.should == true
        end

        [nil, false].each do |value|

          it "returns false if any value is #{value.inspect}" do
            Hamster.set(value, true, "A").all?.should == false
          end

        end

      end

    end

  end

end
