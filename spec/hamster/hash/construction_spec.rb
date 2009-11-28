require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Hash do

  describe ".[]" do

    before do
      @hash = Hamster::Hash["A" => "aye", "B" => "bee", "C" => "see"]
    end

    it "is equivalent to repeatedly using #put" do
      @hash.should == Hamster::Hash.new.put("A", "aye").put("B", "bee").put("C", "see")
    end

  end

end
