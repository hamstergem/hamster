require "hamster/set"

describe Hamster::Set do
  [:dup, :clone].each do |method|
    let(:set) { S["A", "B", "C"] }

    describe "##{method}" do
      it "returns self" do
        expect(set.send(method)).to equal(set)
      end
    end
  end
end
