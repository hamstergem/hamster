require "hamster/hash"

describe Hamster::Hash do
  [:find, :detect].each do |method|
    describe "##{method}" do
      [
        [[], "A", nil],
        [[], nil, nil],
        [["A" => "aye"], "A", ["A", "aye"]],
        [["A" => "aye"], "B", nil],
        [["A" => "aye"], nil, nil],
        [["A" => "aye", "B" => "bee", nil => "NIL"], "A", ["A", "aye"]],
        [["A" => "aye", "B" => "bee", nil => "NIL"], "B", ["B", "bee"]],
        [["A" => "aye", "B" => "bee", nil => "NIL"], nil, [nil, "NIL"]],
        [["A" => "aye", "B" => "bee", nil => "NIL"], "C", nil],
      ].each do |values, key, expected|
        describe "on #{values.inspect}" do
          let(:hash) { H[*values] }

          describe "with a block" do
            it "returns #{expected.inspect}" do
              expect(hash.send(method) { |k, v| k == key }).to eq(expected)
            end
          end

          describe "without a block" do
            it "returns an Enumerator" do
              result = hash.send(method)
              expect(result.class).to be(Enumerator)
              expect(result.each { |k,v| k == key }).to eq(expected)
            end
          end
        end
      end

      it "stops iterating when the block returns true" do
        yielded = []
        H[a: 1, b: 2].find { |k,v| yielded << k; true }
        expect(yielded.size).to eq(1)
      end
    end
  end
end
