require "hamster/list"

describe Hamster::List do
  describe "#drop_while" do
    it "is lazy" do
      expect { Hamster.stream { fail }.drop_while { false } }.not_to raise_error
    end

    [
      [[], []],
      [["A"], []],
      [%w[A B C], ["C"]],
    ].each do |values, expected|
      context "on #{values.inspect}" do
        let(:list) { L[*values] }

        context "with a block" do
          it "preserves the original" do
            list.drop_while { |item| item < "C" }
            expect(list).to eql(L[*values])
          end

          it "returns #{expected.inspect}" do
            expect(list.drop_while { |item| item < "C" }).to eql(L[*expected])
          end
        end

        context "without a block" do
          it "returns an Enumerator" do
            expect(list.drop_while.class).to be(Enumerator)
            expect(list.drop_while.each { false }).to eql(list)
            expect(list.drop_while.each { true  }).to be_empty
          end
        end
      end
    end
  end
end
