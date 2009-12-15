require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/set'

describe Hamster::Set do

  describe ".set" do

    before do
      @set = Hamster.set("A", "B", "C")
    end

    it "is equivalent to repeatedly using #add" do
      @set.should == Hamster.set.add("A").add("B").add("C")
    end

  end

end
