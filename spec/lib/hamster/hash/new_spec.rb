require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  describe ".new" do
    it "is amenable to overriding of #initialize" do
      class SnazzyHash < Hamster::Hash
        def initialize
          super({'snazzy?' => 'oh yeah'})
        end
      end

      hash = SnazzyHash.new
      hash['snazzy?'].should == 'oh yeah'
    end

    describe "from a subclass" do
      it "returns a frozen instance of the subclass" do
        subclass = Class.new(Hamster::Hash)
        instance = subclass.new("some" => "values")
        instance.class.should be(subclass)
        instance.frozen?.should be true
      end
    end

    it "accepts an array as initializer" do
      Hamster::Hash.new([['a', 'b'], ['c', 'd']]).should eql(Hamster.hash('a' => 'b', 'c' => 'd'))
    end
  end
end