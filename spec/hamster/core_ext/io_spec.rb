require "spec_helper"
require "hamster/core_ext/io"

describe IO do
  describe "#to_list" do
    describe "with a File" do
      it "returns an equivalent list" do
        File.open(File.dirname(__FILE__) + "/io_spec.txt") do |io|
          io.to_list.should == Hamster.list("A\n", "B\n", "C\n")
        end
      end
    end

    describe "with a StringIO" do
      it "returns an equivalent list" do
        StringIO.new("A\nB\nC\n").to_list.should == Hamster.list("A\n", "B\n", "C\n")
      end
    end
  end
end
