require 'spec_helper'

require 'hamster/hash'
require 'hamster/set'

describe "Hamster.Hash" do

  describe "#values" do

    before do
      hash = Hamster.Hash("A" => "aye", "B" => "bee", "C" => "see")
      @result = hash.values
    end

    it "returns the keys as a set" do
      @result.should == Hamster.set("aye", "bee", "see")
    end

  end

end
