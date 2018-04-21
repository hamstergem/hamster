require "spec_helper"
require "hamster/set"

describe Hamster::Set do
  [:reject, :delete_if].each do |method|
    describe "##{method}" do
      let(:set) { S["A", "B", "C"] }

      context "when nothing matches" do
        it "returns self" do
          expect(set.send(method) { |item| false }).to equal(set)
        end
      end

      context "when only some things match" do
        context "with a block" do
          let(:result) { set.send(method) { |item| item == "A" }}

          it "preserves the original" do
            result
            expect(set).to eql(S["A", "B", "C"])
          end

          it "returns a set with the matching values" do
            expect(result).to eql(S["B", "C"])
          end
        end

        context "with no block" do
          it "returns self" do
            expect(set.send(method).class).to be(Enumerator)
            expect(set.send(method).each { |item| item == "A" }).to eq(S["B", "C"])
          end
        end
      end

      context "on a large set, with many combinations of input" do
        it "still works" do
          array = (1..1000).to_a
          set   = S.new(array)
          [0, 10, 100, 200, 500, 800, 900, 999, 1000].each do |threshold|
            result = set.send(method) { |item| item > threshold }
            expect(result.size).to eq(threshold)
            1.upto(threshold)  { |n| expect(result.include?(n)).to eq(true) }
            (threshold+1).upto(1000) { |n| expect(result.include?(n)).to eq(false) }
          end
        end
      end
    end
  end
end