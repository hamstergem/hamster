require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Set do

  describe "#include?" do

    before do
      @set = Hamster::Set["A", "B", "C", nil]
    end

    ["A", "B", "C", nil].each do |value|

      it "returns true for an existing value (#{value.inspect})" do
        @set.include?(value).should be_true
      end

    end

    it "returns false for a non-existing value" do
      @set.include?("D").should be_false
    end

  end

end
