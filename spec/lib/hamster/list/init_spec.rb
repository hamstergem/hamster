require "hamster/list"

RSpec.describe Hamster::List do
  describe "#init" do
    it "is lazy" do
      expect { Hamster.stream { false }.init }.not_to raise_error
    end

    [
      [[], []],
      [["A"], []],
      [%w[A B C], %w[A B]],
    ].each do |values, expected|
      context "on #{values.inspect}" do
        let(:list) { L[*values] }

        it "preserves the original" do
          list.init
          expect(list).to eql(L[*values])
        end

        it "returns the list without the last element: #{expected.inspect}" do
          expect(list.init).to eql(L[*expected])
        end
      end
    end
  end
end
