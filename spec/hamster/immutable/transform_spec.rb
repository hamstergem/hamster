require File.expand_path('../../../spec_helper', __FILE__)

require 'hamster/immutable'

describe Hamster::Immutable do

  describe "#transform" do

    class Person < Struct.new(:first, :last)
      include Hamster::Immutable
      public :transform
    end

    before do
      @original = Person.new("Simon", "Harris")
      @result = @original.transform { self.first = "Sampy" }
    end

    it "preserves the original" do
      @original.first.should == "Simon"
      @original.last.should == "Harris"
    end

    it "returns a new instance with the updated values" do
      @result.first.should == "Sampy"
      @result.last.should == "Harris"
    end

  end

end
