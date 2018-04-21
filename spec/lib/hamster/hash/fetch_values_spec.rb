require "hamster/hash"

describe Hamster::Hash do
  describe "#fetch_values" do
    context "when the all the requests keys exist" do
      it "returns a vector of values for the given keys" do
        h = H[:a => 9, :b => 'a', :c => -10, :d => nil]
        expect(h.fetch_values).to be_kind_of(Hamster::Vector)
        expect(h.fetch_values).to eql(V.empty)
        expect(h.fetch_values(:a, :d, :b)).to be_kind_of(Hamster::Vector)
        expect(h.fetch_values(:a, :d, :b)).to eql(V[9, nil, 'a'])
      end
    end

    context "when the key does not exist" do
      it "raises a KeyError" do
        expect { H["A" => "aye", "C" => "Cee"].fetch_values("A", "B") }.to raise_error(KeyError)
      end
    end
  end
end
