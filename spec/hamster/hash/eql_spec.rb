require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Hash do

  describe "#eql?" do

    it "is true for the same instance" do
      hash = Hamster::Hash.new
      hash.should eql(hash)
    end

    it "is true for two empty instances" do
      Hamster::Hash.new.should eql(Hamster::Hash.new)
    end

    it "is true for two instances with the same key/value pairs" do
      a = Hamster::Hash.new.put("a", "Aye").put("b", "Bee").put("c", "See")
      b = Hamster::Hash.new.put("a", "Aye").put("b", "Bee").put("c", "See")
      a.should eql(b)
    end

    it "is false for two instances with different key/value pairs" do
      a = Hamster::Hash.new.put("a", "Aye").put("b", "Bee").put("c", "See")
      b = Hamster::Hash.new.put("a", "Aye").put("b", "Bee").put("d", "Dee")
      a.should_not eql(b)
    end

    it "is false for two instances with different numbers of overlapping key/value pairs" do
      a = Hamster::Hash.new.put("a", "Aye").put("b", "Bee").put("c", "See")
      b = Hamster::Hash.new.put("a", "Aye").put("b", "Bee")
      a.should_not eql(b)
    end

  end

end
