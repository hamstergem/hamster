require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  describe "#uniq" do
    before do
      @vector = Hamster.vector('a', 'b', 'a', 'a', 'c', 'b')
    end

    it "returns a vector with no duplicates" do
      @vector.uniq.should eql(Hamster.vector('a', 'b', 'c'))
    end

    it "leaves the original unmodified" do
      @vector.uniq
      @vector.should eql(Hamster.vector('a', 'b', 'a', 'a', 'c', 'b'))
    end

    it "uses eql? semantics" do
      Hamster.vector(1.0, 1).uniq.should eql(Hamster.vector(1.0, 1))
    end

    context "from a subclass" do
      it "returns an instance of the subclass" do
        @subclass = Class.new(Hamster::Vector)
        @instance = @subclass.new([1,2,3])
        @instance.uniq.class.should be(@subclass)
      end
    end
  end
end