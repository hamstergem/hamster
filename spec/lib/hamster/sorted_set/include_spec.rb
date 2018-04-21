require "hamster/sorted_set"

RSpec.describe Hamster::SortedSet do
  [:include?, :member?].each do |method|
    describe "##{method}" do
      let(:sorted_set) { SS[1, 2, 3, 4.0] }

      [1, 2, 3, 4.0].each do |value|
        it "returns true for an existing value (#{value.inspect})" do
          expect(sorted_set.send(method, value)).to eq(true)
        end
      end

      it "returns false for a non-existing value" do
        expect(sorted_set.send(method, 5)).to eq(false)
      end

      it "uses #<=> for equality" do
        expect(sorted_set.send(method, 4)).to eq(true)
      end
    end
  end
end
