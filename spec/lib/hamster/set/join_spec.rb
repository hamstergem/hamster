require "hamster/set"

RSpec.describe Hamster::Set do
  describe "#join" do
    context "with a separator" do
      [
        [[], ""],
        [["A"], "A"],
        [[DeterministicHash.new("A", 1), DeterministicHash.new("B", 2), DeterministicHash.new("C", 3)], "A|B|C"]
      ].each do |values, expected|
        context "on #{values.inspect}" do
          let(:set) { S[*values] }

          it "preserves the original" do
            set.join("|")
            expect(set).to eql(S[*values])
          end

          it "returns #{expected.inspect}" do
            expect(set.join("|")).to eql(expected)
          end
        end
      end
    end

    context "without a separator" do
      [
        [[], ""],
        [["A"], "A"],
        [[DeterministicHash.new("A", 1), DeterministicHash.new("B", 2), DeterministicHash.new("C", 3)], "ABC"]
      ].each do |values, expected|
        context "on #{values.inspect}" do
          let(:set) { S[*values] }

          it "preserves the original" do
            set.join
            expect(set).to eql(S[*values])
          end

          it "returns #{expected.inspect}" do
            expect(set.join).to eql(expected)
          end
        end
      end
    end

    context "without a separator (with global default separator set)" do
      before { $, = '**' }
      let(:set) { S[DeterministicHash.new("A", 1), DeterministicHash.new("B", 2), DeterministicHash.new("C", 3)] }
      after  { $, = nil }

      context "on ['A', 'B', 'C']" do
        it "preserves the original" do
          set.join
          expect(set).to eql(S[DeterministicHash.new("A", 1), DeterministicHash.new("B", 2), DeterministicHash.new("C", 3)])
        end

        it "returns #{@expected.inspect}" do
          expect(set.join).to eq("A**B**C")
        end
      end
    end
  end
end
