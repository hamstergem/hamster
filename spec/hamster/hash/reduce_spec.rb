require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  [:reduce, :inject, :fold, :foldr].each do |method|
    describe "##{method}" do
      describe "when empty" do
        before do
          @original = Hamster.hash
          @result = @original.send(method, "ABC") {}
        end

        it "returns the memo" do
          @result.should == "ABC"
        end
      end

      describe "when not empty" do
        before do
          @original = Hamster.hash("A" => "aye", "B" => "bee", "C" => "see")
        end

        describe "with a block" do
          before do
            @result = @original.send(method, 0) { |memo, key, value| memo + 1 }
          end

          it "returns the final memo" do
            @result.should == 3
          end
        end

        describe "with no block" do
          before do
            @original = Hamster.hash(a: 1, b: 2)
          end

          it "uses a passed string as the name of a method to use instead" do
            [[:a, 1, :b, 2], [:b, 2, :a, 1]].should include(@original.send(method, "+"))
          end

          it "uses a passed symbol as the name of a method to use instead" do
            [[:a, 1, :b, 2], [:b, 2, :a, 1]].should include(@original.send(method, :+))
          end
        end
      end
    end
  end
end
