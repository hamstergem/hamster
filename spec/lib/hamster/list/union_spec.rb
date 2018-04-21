require "spec_helper"
require "hamster/list"

describe Hamster::List do
  [:union, :|].each do |method|
    describe "##{method}" do
      it "is lazy" do
        expect { Hamster.stream { fail }.union(Hamster.stream { fail }) }.not_to raise_error
      end

      [
        [[], [], []],
        [["A"], [], ["A"]],
        [%w[A B C], [], %w[A B C]],
        [%w[A A], ["A"], ["A"]],
      ].each do |a, b, expected|
        context "returns #{expected.inspect}" do
          let(:list_a) { L[*a] }
          let(:list_b) { L[*b] }

          it "for #{a.inspect} and #{b.inspect}"  do
            expect(list_a.send(method, list_b)).to eql(L[*expected])
          end

          it "for #{b.inspect} and #{a.inspect}"  do
            expect(list_b.send(method, list_a)).to eql(L[*expected])
          end
        end
      end
    end
  end
end