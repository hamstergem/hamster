require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Hash do

  describe "#get" do

    before do
      @hash = Hamster::Hash["A" => "aye", "B" => "bee", "C" => "see"]
    end

    [
      ["A", "aye"],
      ["B", "bee"],
      ["C", "see"],
    ].each do |key, value|

      it "returns the value ('#{value}') for an existing key ('#{key}')" do
        @hash.get(key).should == value
      end

    end

    it "returns nil for a non-existing key ('D')" do
      @hash.get("D").should be_nil
    end

  end

end
