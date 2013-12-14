require "spec_helper"

require "hamster/immutable"

describe Hamster::Immutable do

  describe "#new" do

    class NewPerson < Struct.new(:first, :last)
      include Hamster::Immutable
    end

    before do
      @instance = NewPerson.new("Simon", "Harris")
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
