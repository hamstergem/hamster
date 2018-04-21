require "hamster/hash"

RSpec.describe Hamster::Hash do
  [:reject, :delete_if].each do |method|
    describe "##{method}" do
      let(:hash) { H["A" => "aye", "B" => "bee", "C" => "see"] }

      context "when nothing matches" do
        it "returns self" do
          expect(hash.send(method) { |key, value| false }).to equal(hash)
        end
      end

      context "when only some things match" do
        context "with a block" do
          let(:result) { hash.send(method) { |key, value| key == "A" && value == "aye" }}

          it "preserves the original" do
            result
            expect(hash).to eql(H["A" => "aye", "B" => "bee", "C" => "see"])
          end

          it "returns a set with the matching values" do
            expect(result).to eql(H["B" => "bee", "C" => "see"])
          end

          it "yields entries in the same order as #each" do
            each_pairs = []
            remove_pairs = []
            hash.each_pair { |k,v| each_pairs << [k,v] }
            hash.send(method) { |k,v| remove_pairs << [k,v] }
            expect(each_pairs).to eq(remove_pairs)
          end
        end

        context "with no block" do
          it "returns an Enumerator" do
            expect(hash.send(method).class).to be(Enumerator)
            expect(hash.send(method).to_a.sort).to eq([['A', 'aye'], ['B', 'bee'], ['C', 'see']])
            expect(hash.send(method).each { true }).to eql(H.empty)
          end
        end

        context "on a large hash, with many combinations of input" do
          it "still works" do
            array = 1000.times.collect { |n| [n, n] }
            hash  = H.new(array)
            [0, 10, 100, 200, 500, 800, 900, 999, 1000].each do |threshold|
              result = hash.send(method) { |k,v| k >= threshold}
              expect(result.size).to eq(threshold)
              0.upto(threshold-1) { |n| expect(result.key?(n)).to eq(true) }
              threshold.upto(1000) { |n| expect(result.key?(n)).to eq(false) }
            end
            # shouldn't have changed
            expect(hash).to eql(H.new(1000.times.collect { |n| [n, n] }))
          end
        end
      end
    end
  end
end
