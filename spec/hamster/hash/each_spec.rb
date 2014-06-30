require "spec_helper"

require "hamster/hash"

describe Hamster::Hash do

  before do
    @hash = Hamster.hash("A" => "aye", "B" => "bee", "C" => "see")
  end

  [:each, :foreach, :each_pair].each do |method|

    describe "##{method}" do

      describe "with a block (internal iteration)" do

        it "returns self" do
          @hash.send(method) {}.should be(@hash)
        end

        it "yields all key/value pairs" do
          actual_pairs = {}
          @hash.send(method) { |key, value| actual_pairs[key] = value }
          actual_pairs.should == { "A" => "aye", "B" => "bee", "C" => "see" }
        end

      end

      describe "with no block" do

        it "returns an Enumerator" do
          @result = @hash.send(method)
          @result.class.should be(Enumerator)
          @result.to_a.should == @hash.to_a
        end

      end

    end

  end

  describe "#each_key" do

    it "yields all keys" do
      keys = []
      @hash.each_key { |k| keys << k }
      keys.sort.should == ['A', 'B', 'C']
    end

    context "with no block" do

      it "returns an Enumerator" do
        @hash.each_key.class.should be(Enumerator)
        @hash.each_key.to_a.sort.should == ['A', 'B', 'C']
      end

    end

  end

  describe "#each_value" do

    it "yields all values" do
      values = []
      @hash.each_value { |v| values << v }
      values.sort.should == ['aye', 'bee', 'see']
    end

    context "with no block" do

      it "returns an Enumerator" do
        @hash.each_value.class.should be(Enumerator)
        @hash.each_value.to_a.sort.should == ['aye', 'bee', 'see']
      end

    end

  end

end
