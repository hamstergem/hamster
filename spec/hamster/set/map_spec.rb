require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Set do

  [:map, :collect].each do |method|

    describe "##{method}" do

      describe "when empty" do

        before do
          @original = Hamster.set
          @mapped = @original.send(method) {}
        end

        it "returns self" do
          @mapped.should equal(@original)
        end

      end

      describe "when not empty" do

        before do
          @original = Hamster.set("A", "B", "C")
        end

        describe "with a block" do

          before do
            @mapped = @original.send(method) { |item| item.downcase }
          end

          it "preserves the original values" do
            @original.should == Hamster.set("A", "B", "C")
          end

          it "returns a new set with the mapped values" do
            @mapped.should == Hamster.set("a", "b", "c")
          end

        end

        describe "with no block" do

          before do
            @enumerator = @original.send(method)
          end

          it "preserves the original values" do
            @original.should == Hamster.set("A", "B", "C")
          end

          it "returns an enumerator over the values" do
            Hamster.set(*@enumerator.to_a).should == @original
          end

        end

      end

    end

  end

end
