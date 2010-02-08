require File.expand_path('../../../spec_helper', __FILE__)

require 'hamster/tuple'

describe Hamster::Tuple do

  describe "#inspect" do

    before do
      @list = Hamster::Tuple.new("A", "B")
    end

    it "returns a string with the inspected values" do
      @list.inspect.should == "(\"A\", \"B\")"
    end

  end

end
