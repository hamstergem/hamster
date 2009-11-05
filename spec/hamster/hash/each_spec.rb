require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Hash do

  describe "#each" do

    before do
      @hash = Hamster::Hash.new
      @expected_pairs = { "A" => "aye", "B" => "bee", "C" => "sea" }
      @expected_pairs.each do |key, value|
        @hash = @hash.put(key, value)
      end
    end

    describe "with a block (internal iteration)" do

      it "returns self" do
        @hash.each {}.should equal(@hash)
      end

      it "yields all key value pairs" do
        actual_pairs = {}
        @hash.each do |key, value|
          actual_pairs[key] = value
        end
        actual_pairs.should == @expected_pairs
      end

    end

    describe "with no block (external iteration)" do

      it "returns an enumerator over all key value pairs" do
        actual_pairs = {}
        enum = @hash.each
        loop do
          key, value = enum.next
          actual_pairs[key] = value
        end
        actual_pairs.should == @expected_pairs
      end

    end

  end

end
