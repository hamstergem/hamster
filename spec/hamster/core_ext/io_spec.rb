require 'spec_helper'

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
