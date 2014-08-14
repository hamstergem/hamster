require "spec_helper"
require "hamster/sorted_set"

describe Hamster::SortedSet do
  describe "#fetch" do
    before do
      @sorted_set = Hamster.sorted_set('a', 'b', 'c')
    end

    context "with no default provided" do
      context "when the index exists" do
        it "returns the value at the index" do
          @sorted_set.fetch(0).should == "a"
          @sorted_set.fetch(1).should == "b"
          @sorted_set.fetch(2).should == "c"
        end
      end

      context "when the key does not exist" do
        it "raises an IndexError" do
          -> { @sorted_set.fetch(3) }.should raise_error(IndexError)
          -> { @sorted_set.fetch(-4) }.should raise_error(IndexError)
        end
      end
    end

    context "with a default value" do
      context "when the index exists" do
        it "returns the value at the index" do
          @sorted_set.fetch(0, "default").should == "a"
          @sorted_set.fetch(1, "default").should == "b"
          @sorted_set.fetch(2, "default").should == "c"
        end
      end

      context "when the index does not exist" do
        it "returns the default value" do
          @sorted_set.fetch(3, "default").should == "default"
          @sorted_set.fetch(-4, "default").should == "default"
        end
      end
    end

    context "with a default block" do
      context "when the index exists" do
        it "returns the value at the index" do
          @sorted_set.fetch(0) { "default".upcase }.should == "a"
          @sorted_set.fetch(1) { "default".upcase }.should == "b"
          @sorted_set.fetch(2) { "default".upcase }.should == "c"
        end
      end

      context "when the key does not exist" do
        it "returns the default value" do
          @sorted_set.fetch(3) { "default".upcase }.should == "DEFAULT"
          @sorted_set.fetch(-4) { "default".upcase }.should == "DEFAULT"
        end
      end
    end
  end
end