require "hamster/vector"

describe Hamster::Vector do
  describe "#join" do
    context "with a separator" do
      [
        [[], ""],
        [["A"], "A"],
        [[DeterministicHash.new("A", 1), DeterministicHash.new("B", 2), DeterministicHash.new("C", 3)], "A|B|C"]
      ].each do |values, expected|
        describe "on #{values.inspect}" do
          let(:vector) { V[*values] }

          it "preserves the original" do
            vector.join("|")
            expect(vector).to eql(V[*values])
          end

          it "returns #{expected.inspect}" do
            expect(vector.join("|")).to eq(expected)
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
        describe "on #{values.inspect}" do
          let(:vector) { V[*values] }

          it "preserves the original" do
            vector.join
            expect(vector).to eql(V[*values])
          end

          it "returns #{expected.inspect}" do
            expect(vector.join).to eq(expected)
          end
        end
      end
    end

    context "without a separator (with global default separator set)" do
      before { $, = '**' }
      after  { $, = nil }

      describe 'on ["A", "B", "C"]' do
        it 'returns "A**B**C"' do
          expect(V["A", "B", "C"].join).to eq("A**B**C")
        end
      end
    end
  end
end
