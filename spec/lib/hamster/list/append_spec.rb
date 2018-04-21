require "hamster/list"

RSpec.describe Hamster::List do
  [:append, :concat, :+].each do |method|
    describe "##{method}" do
      it "is lazy" do
        expect { Hamster.stream { fail }.append(Hamster.stream { fail }) }.not_to raise_error
      end

      [
        [[], [], []],
        [["A"], [], ["A"]],
        [[], ["A"], ["A"]],
        [%w[A B], %w[C D], %w[A B C D]],
      ].each do |left_values, right_values, expected|
        context "on #{left_values.inspect} and #{right_values.inspect}" do
          let(:left) { L[*left_values] }
          let(:right) { L[*right_values] }
          let(:result) { left.append(right) }

          it "preserves the left" do
            result
            expect(left).to eql(L[*left_values])
          end

          it "preserves the right" do
            result
            expect(right).to eql(L[*right_values])
          end

          it "returns #{expected.inspect}" do
            expect(result).to eql(L[*expected])
          end
        end
      end
    end
  end
end
