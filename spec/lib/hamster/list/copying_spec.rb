require "hamster/list"

describe Hamster::List do
  [:dup, :clone].each do |method|
    [
      [],
      ["A"],
      %w[A B C],
    ].each do |values|
      context "on #{values.inspect}" do
        let(:list) { L[*values] }

        it "returns self" do
          expect(list.send(method)).to equal(list)
        end
      end
    end
  end
end
