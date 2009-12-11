require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Set do

  [:filter, :select, :find_all].each do |method|

    describe "##{method}" do

      before do
        @original = Hamster.set("A", "B", "C")
      end

      describe "when everything matches" do

        before do
          @result = @original.send(method) { |item| true }
        end

        it "returns self" do
          @result.should equal(@original)
        end

      end

      describe "when only some things match" do

        describe "with a block" do

          before do
            @result = @original.send(method) { |item| item == "A" }
          end

          it "preserves the original" do
            @original.should == Hamster.set("A", "B", "C")
          end

          it "returns a set with the matching values" do
            @result.should == Hamster.set("A")
          end

        end

        describe "with no block" do

          before do
            @result = @original.send(method)
          end

          it "returns self" do
            @result.should equal(@original)
          end

        end

      end

    end

  end

end
