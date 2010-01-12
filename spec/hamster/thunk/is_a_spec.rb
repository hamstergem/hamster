require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/thunk'

describe Hamster::Thunk do

  describe "#is_a?" do

    before do
      @thunk = Hamster::Thunk.new { 1 }
    end

    it "returns true if the undlerying object returns true" do
      @thunk.is_a?(Fixnum).should == true
    end

    it "returns false if the underlying object returns false" do
      @thunk.is_a?(String).should == false
    end

  end

end
