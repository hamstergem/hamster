require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#map" do

    it "initially returns self" do
      list = Hamster::List.new
      list.map {}.should equal(list)
    end

    describe "when not empty" do

      before do
        @original = Hamster::List[1, 2, 3, 4]
        @copy = @original.map { |i| i + 5 }
      end

      it "returns a modified copy" do
        @copy.should_not equal(@original)
      end

      describe "the original" do

        it "has the original values" do
          @original.to_enum.to_a.should == [1, 2, 3, 4]
        end

      end

      describe "the modified copy" do

        it "has the mapped values" do
          @copy.to_enum.to_a.should == [6, 7, 8, 9]
        end

      end

    end

  end

end
