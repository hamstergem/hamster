require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  describe "#shuffle" do
    before do
      @vector = Hamster.vector(1,2,3,4)
    end

    it "returns the same values, in a usually different order" do
      different = false
      10.times do
        shuffled = @vector.shuffle
        shuffled.sort.should eql(@vector)
        different ||= (shuffled != @vector)
      end
      different.should be_true
    end

    it "leaves the original unchanged" do
      @vector.shuffle
      @vector.should eql(Hamster.vector(1,2,3,4))
    end

    context "from a subclass" do
      it "returns an instance of the subclass" do
        @subclass = Class.new(Hamster::Vector)
        @instance = @subclass.new([1,2,3])
        @instance.shuffle.class.should be(@subclass)
      end
    end
  end
end