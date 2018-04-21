require "hamster/list"

RSpec.describe Hamster::List do
  describe "#drop" do
    it "is lazy" do
      expect { Hamster.stream { fail }.drop(1) }.not_to raise_error
    end

    [
      [[], 10, []],
      [["A"], 10, []],
      [["A"], -1, ["A"]],
      [%w[A B C], 0, %w[A B C]],
      [%w[A B C], 2, ["C"]],
    ].each do |values, number, expected|
      context "with #{number} from #{values.inspect}" do
        let(:list) { L[*values] }

        it "preserves the original" do
          list.drop(number)
          expect(list).to eql(L[*values])
        end

        it "returns #{expected.inspect}" do
          expect(list.drop(number)).to eq(L[*expected])
        end
      end
    end
  end
end
