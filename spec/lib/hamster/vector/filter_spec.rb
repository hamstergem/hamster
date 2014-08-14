require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  [:filter, :select, :find_all].each do |method|
    describe "##{method}" do
      before do
        @original = Hamster.vector("A", "B", "C")
      end

      describe "with a block" do
        before do
          @result = @original.send(method) { |item| item == "A" }
        end

        it "preserves the original" do
          @original.should == Hamster.vector("A", "B", "C")
        end

        it "returns a vector with the matching values" do
          @result.should == Hamster.vector("A")
        end
      end

      describe "with no block" do
        before do
          @result = @original.send(method)
        end

        it "returns an Enumerator" do
          @result.class.should be(Enumerator)
          @result.each { |item| item == "A" }.should == Hamster.vector("A")
        end
      end

      describe "when nothing matches" do
        before do
          @result = @original.send(method) { |item| false }
        end

        it "preserves the original" do
          @original.should == Hamster.vector("A", "B", "C")
        end

        it "returns an empty vector" do
          @result.should equal(Hamster.vector)
        end
      end

      context "from a subclass" do
        it "returns an instance of the subclass" do
          @subclass = Class.new(Hamster::Vector)
          @instance = @subclass[1,2,3]
          @instance.filter { |x| x > 1 }.class.should be(@subclass)
        end
      end
    end
  end
end