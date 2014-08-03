require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  before do
    @vector = Hamster.vector(1..1000)
  end

  describe "#reverse_each" do
    describe "with a block (internal iteration)" do
      it "returns self" do
        @vector.reverse_each {}.should be(@vector)
      end

      it "yields all items in the opposite order as #each" do
        result = []
        @vector.reverse_each { |item| result << item }
        result.should eql(@vector.to_a.reverse)
      end
    end

    describe "with no block" do
      it "returns an Enumerator" do
        @result = @vector.reverse_each
        @result.class.should be(Enumerator)
        @result.to_a.should eql(@vector.to_a.reverse)
      end
    end
  end
end