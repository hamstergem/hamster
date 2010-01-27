require File.expand_path('../../spec_helper', File.dirname(__FILE__))

require 'hamster/tuple'

describe Hamster::Tuple do

  describe "#first" do

    before do
      @tuple = Hamster::Tuple.new("A", "B")
    end

    it "returns the first value" do
      @tuple.first.should == "A"
    end

  end

end
