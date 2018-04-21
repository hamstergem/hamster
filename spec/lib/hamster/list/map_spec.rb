require "hamster/list"

RSpec.describe Hamster::List do
  [:map, :collect].each do |method|
    describe "##{method}" do
      it "is lazy" do
        expect { Hamster.stream { fail }.map { |item| item } }.not_to raise_error
      end

      [
        [[], []],
        [["A"], ["a"]],
        [%w[A B C], %w[a b c]],
      ].each do |values, expected|
        context "on #{values.inspect}" do
          let(:list) { L[*values] }

          context "with a block" do
            it "preserves the original" do
              list.send(method, &:downcase)
              expect(list).to eql(L[*values])
            end

            it "returns #{expected.inspect}" do
              expect(list.send(method, &:downcase)).to eql(L[*expected])
            end

            it "is lazy" do
              count = 0
              list.send(method) { |item| count += 1 }
              expect(count).to be <= 1
            end
          end

          context "without a block" do
            it "returns an Enumerator" do
              expect(list.send(method).class).to be(Enumerator)
              expect(list.send(method).each(&:downcase)).to eql(L[*expected])
            end
          end
        end
      end
    end
  end
end
