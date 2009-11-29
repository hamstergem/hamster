require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Set do

  describe "#empty?" do

    describe "when empty" do

      before do
        @set = Hamster::Set[]
      end

      it "returns true" do
        @set.should be_empty
      end

    end

    describe "when not empty" do

      before do
        @set = Hamster::Set["A", "B", "C"]
      end

      it "returns false" do
        @set.should_not be_empty
      end

    end

  end

end
