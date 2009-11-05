require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#map" do

    it "initially returns self" do
      list = Hamster::List.new
      list.map {}.should equal(list)
    end

    describe "when not empty" do

      before do
        @original = Hamster::List.new.cons(1).cons(2).cons(3).cons(4)
        @copy = @original.map { |i| i + 5 }
      end

      it "returns a modified copy" do
        @copy.should_not equal(@original)
      end

      describe "the original" do

        it "has the original values" do
          @original.to_enum.to_a.should == [4, 3, 2, 1]
        end

      end

      describe "the modified copy" do

        it "has the mapped values" do
          @copy.to_enum.to_a.should == [9, 8, 7, 6]
        end

      end

    end

  end

end
