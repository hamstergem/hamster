require "hamster/hash"

RSpec.describe Hamster::Hash do
  let(:hash) { H["A" => "aye", "B" => "bee", "C" => "see"] }

  [:dup, :clone].each do |method|
    describe "##{method}" do
      it "returns self" do
        expect(hash.send(method)).to equal(hash)
      end
    end
  end
end
