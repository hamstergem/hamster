require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/thunk'

describe Hamster::Thunk do

  [:eql?, :==].each do |method|

    describe "##{method}" do

      before do
        @thunk = Hamster::Thunk.new { 1 }
      end

      it "returns true if the undlerying object returns true" do
        @thunk.send(method, 1).should == true
      end

      it "returns false if the underlying object returns false" do
        @thunk.send(method, 2).should == false
      end

    end

  end

end
