require File.expand_path('../../spec_helper', File.dirname(__FILE__))

require 'hamster/core_ext/io'

describe IO do

  describe "#to_list" do

    it "returns an equivalent list" do
      File.open(File.dirname(__FILE__) + "/io_spec.txt") do |io|
        io.to_list.should == Hamster.list("A\n", "B\n", "C\n")
      end
    end

  end

end
