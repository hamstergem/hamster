require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  [:+, :concat].each do |method|
    describe "##{method}" do
      before do
        @vector = Hamster::Vector.new(1..100)
      end

      it "appends the elements in the other enumerable" do
        @vector.concat([1,2,3]).should eql(Hamster::Vector.new((1..100).to_a + [1,2,3]))
        @vector.concat(1..1000).should eql(Hamster::Vector.new((1..100).to_a + (1..1000).to_a))
        @vector.concat(1..200).size.should == 300
        @vector.concat(Hamster::EmptyVector).should eql(@vector)
        Hamster::EmptyVector.concat(@vector).should eql(@vector)
      end
    end
  end
end