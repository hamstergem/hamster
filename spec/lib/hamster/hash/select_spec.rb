require "hamster/hash"

RSpec.describe Hamster::Hash do
  [:select, :find_all, :keep_if].each do |method|
    describe "##{method}" do
      let(:original) { H["A" => "aye", "B" => "bee", "C" => "see"] }

      context "when everything matches" do
        it "returns self" do
          expect(original.send(method) { |key, value| true }).to equal(original)
        end
      end

      context "when only some things match" do
        context "with a block" do
          let(:result) { original.send(method) { |key, value| key == "A" && value == "aye" }}

          it "preserves the original" do
            expect(original).to eql(H["A" => "aye", "B" => "bee", "C" => "see"])
          end

          it "returns a set with the matching values" do
            expect(result).to eql(H["A" => "aye"])
          end
        end

        it "yields entries as [key, value] pairs" do
          original.send(method) do |e|
            expect(e).to be_kind_of(Array)
            expect(["A", "B", "C"].include?(e[0])).to eq(true)
            expect(["aye", "bee", "see"].include?(e[1])).to eq(true)
          end
        end

        context "with no block" do
          it "returns an Enumerator" do
            expect(original.send(method).class).to be(Enumerator)
            expect(original.send(method).to_a.sort).to eq([['A', 'aye'], ['B', 'bee'], ['C', 'see']])
          end
        end
      end

      it "works on a large hash, with many combinations of input" do
        keys = (1..1000).to_a
        original = H.new(keys.zip(2..1001))
        25.times do
          threshold = rand(1000)
          result    = original.send(method) { |k,v| k <= threshold }
          expect(result.size).to eq(threshold)
          result.each_key { |k| expect(k).to be <= threshold }
          (threshold+1).upto(1000) { |k| expect(result.key?(k)).to eq(false) }
        end
        expect(original).to eql(H.new(keys.zip(2..1001))) # shouldn't have changed
      end
    end
  end
end
