require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do

  [:any?, :exist?, :exists?].each do |method|

    describe "##{method}" do

      describe "when empty" do

        before do
          @vector = Hamster.vector
        end

        it "with a block returns false" do
          @vector.send(method) {}.should == false
        end

        it "with no block returns false" do
          @vector.send(method).should == false
        end

      end

      describe "when not empty" do

        describe "with a block" do

          before do
            @vector = Hamster.vector("A", "B", "C", nil)
          end

          ["A", "B", "C", nil].each do |value|

            it "returns true if the block ever returns true (#{value.inspect})" do
              @vector.send(method) { |item| item == value }.should == true
            end

          end

          it "returns false if the block always returns false" do
            @vector.send(method) { |item| item == "D" }.should == false
          end

        end

        describe "with no block" do

          it "returns true if any value is truthy" do
            Hamster.vector(nil, false, "A", true).send(method).should == true
          end

          it "returns false if all values are falsey" do
            Hamster.vector(nil, false).send(method).should == false
          end

        end

      end

    end

  end

end
