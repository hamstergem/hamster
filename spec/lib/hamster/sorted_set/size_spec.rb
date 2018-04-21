require "hamster/sorted_set"

RSpec.describe Hamster::SortedSet do
  [:size, :length].each do |method|
    describe "##{method}" do
      [
        [[], 0],
        [["A"], 1],
        [%w[A B C], 3],
      ].each do |values, result|
        it "returns #{result} for #{values.inspect}" do
          expect(SS[*values].send(method)).to eq(result)
        end
      end
    end
  end
end
