require File.expand_path('../../spec_helper', File.dirname(__FILE__))

require 'hamster/tuple'

describe Hamster::Tuple do

  describe "#last" do

    before do
      @tuple = Hamster::Tuple.new("A", "B")
    end

    it "returns the last value" do
      @tuple.last.should == "B"
    end

  end

end
