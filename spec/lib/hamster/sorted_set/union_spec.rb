require "hamster/sorted_set"

RSpec.describe Hamster::SortedSet do
  [:union, :|, :+, :merge].each do |method|
    describe "##{method}" do
      [
        [[], [], []],
        [["A"], [], ["A"]],
        [["A"], ["A"], ["A"]],
        [%w[A B C], [], %w[A B C]],
        [%w[A C E G X], %w[B C D E H M], %w[A B C D E G H M X]]
      ].each do |a, b, expected|
        context "for #{a.inspect} and #{b.inspect}" do
          it "returns #{expected.inspect}" do
            expect(SS[*a].send(method, SS[*b])).to eql(SS[*expected])
          end
        end

        context "for #{b.inspect} and #{a.inspect}" do
          it "returns #{expected.inspect}" do
            expect(SS[*b].send(method, SS[*a])).to eql(SS[*expected])
          end
        end
      end
    end
  end
end
