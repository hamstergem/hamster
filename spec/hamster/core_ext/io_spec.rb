require "spec_helper"
require "hamster/core_ext/io"

describe IO do
  describe "#to_list" do

    after(:each) do
      io.close
    end

    context "with a File" do
      let(:io) { File.new(fixture_path("io_spec.txt")) }

      it "returns an equivalent list" do
        fixture("io_spec.txt").to_list.should == Hamster.list("A\n", "B\n", "C\n")
      end
    end

    context "with a StringIO" do
      let(:io) { StringIO.new(fixture("io_spec.txt")) }

      it "returns an equivalent list" do
        StringIO.new("A\nB\nC\n").to_list.should == Hamster.list("A\n", "B\n", "C\n")
      end
    end
  end
end
