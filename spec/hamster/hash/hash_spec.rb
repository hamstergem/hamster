require 'spec_helper'

require 'hamster/hash'

describe "Hamster.Hash" do

  describe "#hash" do

    it "values are sufficiently distributed" do
      (1..4000).
        each_slice(4).
        map { |ka, va, kb, vb| Hamster.Hash(ka => va, kb => vb).hash }.
        uniq.
        size.should == 1000
    end

    it "differs given the same keys and different values" do
      Hamster.Hash("ka" => "va").hash.should_not == Hamster.Hash("ka" => "vb").hash
    end

    it "differs given the same values and different keys" do
      Hamster.Hash("ka" => "va").hash.should_not == Hamster.Hash("kb" => "va").hash
    end

    describe "on an empty hash" do

      before do
        @result = Hamster.Hash.hash
      end

      it "returns 0" do
        @result.should == 0
      end

    end

  end

end
