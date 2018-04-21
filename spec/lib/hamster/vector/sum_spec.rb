require "hamster/vector"

RSpec.describe Hamster::Vector do
  describe "#sum" do
    [
      [[], 0],
      [[2], 2],
      [[1, 3, 5, 7, 11], 27],
    ].each do |values, expected|
      describe "on #{values.inspect}" do
        it "returns #{expected.inspect}" do
          expect(V[*values].sum).to eq(expected)
        end
      end
    end
  end
end
