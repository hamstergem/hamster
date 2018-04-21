require "hamster/set"

RSpec.describe Hamster::Set do
  [:union, :|, :+, :merge].each do |method|
    describe "##{method}" do
      [
        [[], [], []],
        [["A"], [], ["A"]],
        [["A"], ["A"], ["A"]],
        [[], ["A"], ["A"]],
        [%w[A B C], [], %w[A B C]],
        [%w[A B C], %w[A B C], %w[A B C]],
        [%w[A B C], %w[X Y Z], %w[A B C X Y Z]]
      ].each do |a, b, expected|
        context "for #{a.inspect} and #{b.inspect}" do
          let(:set_a) { S[*a] }
          let(:set_b) { S[*b] }

          it "returns #{expected.inspect}, without changing the original Sets" do
            expect(set_a.send(method, set_b)).to eql(S[*expected])
            expect(set_a).to eql(S.new(a))
            expect(set_b).to eql(S.new(b))
          end
        end

        context "for #{b.inspect} and #{a.inspect}" do
          let(:set_a) { S[*a] }
          let(:set_b) { S[*b] }

          it "returns #{expected.inspect}, without changing the original Sets" do
            expect(set_b.send(method, set_a)).to eql(S[*expected])
            expect(set_a).to eql(S.new(a))
            expect(set_b).to eql(S.new(b))
          end
        end

        context "when passed a Ruby Array" do
          it "returns the expected Set" do
            expect(S[*a].send(method, b.freeze)).to eql(S[*expected])
            expect(S[*b].send(method, a.freeze)).to eql(S[*expected])
          end
        end

        context "from a subclass" do
          it "returns an instance of the subclass" do
            subclass = Class.new(Hamster::Set)
            expect(subclass.new(a).send(method, S.new(b)).class).to be(subclass)
            expect(subclass.new(b).send(method, S.new(a)).class).to be(subclass)
          end
        end
      end

      context "when receiving a subset" do
        let(:set_a) { S.new(1..300) }
        let(:set_b) { S.new(1..200) }

        it "returns self" do
          expect(set_a.send(method, set_b)).to be(set_a)
        end
      end
    end
  end
end
