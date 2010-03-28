require File.expand_path('../../../spec_helper', __FILE__)

require 'hamster/immutable'

describe Hamster::Immutable do

  describe "#new" do

    class Person < Struct.new(:first, :last)
      include Hamster::Immutable
    end

    before do
      @instance = Person.new("Simon", "Harris")
    end

    it "passes the constructor arguments" do
      @instance.first.should == "Simon"
      @instance.last.should == "Harris"
    end

    it "freezes the instance" do
      @instance.should be_frozen
    end

  end

end
