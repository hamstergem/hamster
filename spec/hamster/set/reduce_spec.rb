require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Set do

  [:reduce, :inject].each do |method|

    describe "##{method}" do

      describe "when empty" do

        before do
          @original = Hamster::Set[]
          @result = @original.send(method, "ABC") {}
        end

        it "returns the memo" do
          @result.should == "ABC"
        end

      end

      describe "when not empty" do

        before do
          @original = Hamster::Set["A", "B", "C"]
        end

        describe "with a block" do

          before do
            @result = @original.send(method, 0) { |memo, item| memo + 1 }
          end

          it "returns the final memo" do
            @result.should == 3
          end

        end

        describe "with no block" do

          before do
            @result = @original.send(method, "ABC")
          end

          it "returns the memo" do
            @result.should == "ABC"
          end

        end

      end

    end

  end

end
