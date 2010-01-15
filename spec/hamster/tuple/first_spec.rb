require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/tuple'

describe Hamster::Tuple do

  describe "#first" do

    before do
      @tuple = Hamster.tuple("A", "B")
    end

    it "returns the first value" do
      @tuple.first.should == "A"
    end

  end

end
