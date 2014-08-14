require "spec_helper"
require "hamster/sorted_set"

describe Hamster::SortedSet do
  [:map, :collect].each do |method|
    describe "##{method}" do
      context "when empty" do
        before do
          @original = Hamster.sorted_set
          @mapped = @original.send(method) {}
        end

        it "returns self" do
          @mapped.should equal(@original)
        end
      end

      context "when not empty" do
        before do
          @original = Hamster.sorted_set("A", "B", "C")
        end

        context "with a block" do
          before do
            @mapped = @original.send(method, &:downcase)
          end

          it "preserves the original values" do
            @original.should == Hamster.sorted_set("A", "B", "C")
          end

          it "returns a new set with the mapped values" do
            @mapped.should == Hamster.sorted_set("a", "b", "c")
          end
        end

        context "with no block" do
          before do
            @result = @original.send(method)
          end

          it "returns an Enumerator" do
            @result.class.should be(Enumerator)
            @result.each(&:downcase).should == Hamster.sorted_set('a', 'b', 'c')
          end
        end
      end
    end
  end
end