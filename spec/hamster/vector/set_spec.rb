require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do

  describe "#set" do

    describe "when empty" do

      before do
        @vector = Hamster.vector
      end

      it "always raises an error" do
        (-1..1).each do |i|
          lambda { @vector.set(i) }.should raise_error
        end
      end

    end

    describe "when not empty" do

      before do
        @original = Hamster.vector("A", "B", "C")
      end

      describe "with a block" do

        describe "and a positive index" do

          describe "within the absolute bounds of the vector" do

            it "passes the current value to the block" do
              @original.set(1) { |value| value.should == "B" }
            end

            it "replaces the value with the result of the block" do
              result = @original.set(1) { |value| "FLIBBLE" }
              result.should == Hamster.vector("A", "FLIBBLE", "C")
            end

            it "supports to_proc methods" do
              result = @original.set(1, &:downcase)
              result.should == Hamster.vector("A", "b", "C")
            end

          end

          describe "outside the absolute bounds of the vector" do

            it "raises an error" do
              lambda { @original.set(@original.size) {} }.should raise_error
            end

          end

        end

        describe "and a negative index" do

          describe "within the absolute bounds of the vector" do

            it "passes the current value to the block" do
              @original.set(-2) { |value| value.should == "B" }
            end

            it "replaces the value with the result of the block" do
              result = @original.set(-2) { |value| "FLIBBLE" }
              result.should == Hamster.vector("A", "FLIBBLE", "C")
            end

            it "supports to_proc methods" do
              result = @original.set(-2, &:downcase)
              result.should == Hamster.vector("A", "b", "C")
            end

          end

          describe "outside the absolute bounds of the vector" do

            it "raises an error" do
              lambda { @original.set(-@original.size.next) {} }.should raise_error
            end

          end

        end

      end

      describe "with a value" do

        describe "and a positive index" do

          describe "within the absolute bounds of the vector" do

            before do
              @result = @original.set(1, "FLIBBLE")
            end

            it "preserves the original" do
              @original.should == Hamster.vector("A", "B", "C")
            end

            it "sets the new value at the specified index" do
              @result.should == Hamster.vector("A", "FLIBBLE", "C")
            end

          end

          describe "outside the absolute bounds of the vector" do

            it "raises an error" do
              lambda { @original.set(@original.size, "FLIBBLE") }.should raise_error
            end

          end

        end

        describe "with a negative index" do

          before do
            @result = @original.set(-2, "FLIBBLE")
          end

          it "preserves the original" do
            @original.should == Hamster.vector("A", "B", "C")
          end

          it "sets the new value at the specified index" do
            @result.should == Hamster.vector("A", "FLIBBLE", "C")
          end

        end

        describe "outside the absolute bounds of the vector" do

          it "raises an error" do
            lambda { @original.set(-@original.size.next, "FLIBBLE") }.should raise_error
          end

        end

      end

    end

  end

end
