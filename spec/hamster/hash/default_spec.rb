require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  describe "#default_proc" do
    before do
      @hash = Hamster::Hash.new(1 => 2, 2 => 4) { |k| k * 2 }
    end

    it "returns the default block given when the Hash was created" do
      @hash.default_proc.class.should be(Proc)
      @hash.default_proc.call(3).should == 6
    end

    context "after a key/val pair are inserted" do
      it "doesn't change" do
        @other = @hash.put(3, 6)
        @other.default_proc.should be(@hash.default_proc)
        @other.default_proc.call(4).should == 8
      end
    end

    context "after all key/val pairs are filtered out" do
      it "doesn't change" do
        @other = @hash.remove { true }
        @other.default_proc.should be(@hash.default_proc)
        @other.default_proc.call(4).should == 8
      end
    end

    context "after Hash is inverted" do
      it "doesn't change" do
        @other = @hash.invert
        @other.default_proc.should be(@hash.default_proc)
        @other.default_proc.call(4).should == 8
      end
    end
  end
end