require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Set do

  describe "#include?" do

    before do
      @set = Hamster::Set["A", "B", "C"]
    end

    ["A", "B", "C"].each do |value|

      it "returns true for an existing value ('#{value}')" do
        @set.should include(value)
      end

    end

    it "returns nil for a non-existing value ('D')" do
      @set.should_not include("D")
    end

  end

end
