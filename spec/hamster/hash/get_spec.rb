require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Hash do

  describe "#get" do

    before do
      @hash = Hamster::Hash["A" => "aye", "B" => "bee", "C" => "see", nil => "NIL"]
    end

    [
      ["A", "aye"],
      ["B", "bee"],
      ["C", "see"],
      [nil, "NIL"]
    ].each do |key, value|

      it "returns the value (#{value.inspect}) for an existing key (#{key.inspect})" do
        @hash.get(key).should == value
      end

    end

    it "returns nil for a non-existing key" do
      @hash.get("D").should be_nil
    end

  end

end
