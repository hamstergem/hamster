require "spec_helper"
require "hamster/core_ext/io"

describe IO do
  describe "#to_list" do

    after(:each) do
      io.close
    end

    context "with a File" do
      it "returns an equivalent list" do
        fixture("io_spec.txt").to_list.should == Hamster.list("A\n", "B\n", "C\n")
      end
    end

    context "with a StringIO" do
      it "returns an equivalent list" do
        StringIO.new("A\nB\nC\n").to_list.should == Hamster.list("A\n", "B\n", "C\n")
      end
    end
  end
end
