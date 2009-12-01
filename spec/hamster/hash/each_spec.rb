require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Hash do

  describe "#each" do

    before do
      @hash = Hamster.hash("A" => "aye", "B" => "bee", "C" => "see")
    end

    describe "with a block (internal iteration)" do

      it "returns self" do
        @hash.each {}.should equal(@hash)
      end

      it "yields all key/value pairs" do
        actual_pairs = {}
        @hash.each { |key, value| actual_pairs[key] = value }
        actual_pairs.should == {"A" => "aye", "B" => "bee", "C" => "see"}
      end

    end

    describe "with no block (external iteration)" do

      it "returns an enumerator over all key/value pairs" do
        Hash[*@hash.each.to_a.flatten].should == {"A" => "aye", "B" => "bee", "C" => "see"}
      end

    end

  end

end
