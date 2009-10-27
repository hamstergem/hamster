require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module Hamster

  describe Stack do

    describe "#push" do
      
      before do
        @original = Stack.new.push("A")
        @copy = @original.push("B")
      end

      it "returns a modified copy" do
        @copy.should_not == @original
      end

      describe "the original" do

        it "still has the original top" do
          @original.top.should == "A"
        end

        it "still has the original size" do
          @original.size.should == 1
        end

      end

      describe "the modified copy" do

        it "has a new top" do
          @copy.top.should == "B"
        end

        it "size is increased by one" do
          @copy.size == 2
        end

      end

    end

  end

end
