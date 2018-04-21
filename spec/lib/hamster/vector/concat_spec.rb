require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  [:+, :concat].each do |method|
    describe "##{method}" do
      let(:vector) { V.new(1..100) }

      it "preserves the original" do
        vector.concat([1,2,3])
        expect(vector).to eql(V.new(1..100))
      end

      it "appends the elements in the other enumerable" do
        expect(vector.concat([1,2,3])).to eql(V.new((1..100).to_a + [1,2,3]))
        expect(vector.concat(1..1000)).to eql(V.new((1..100).to_a + (1..1000).to_a))
        expect(vector.concat(1..200).size).to eq(300)
        expect(vector.concat(vector)).to eql(V.new((1..100).to_a * 2))
        expect(vector.concat(V.empty)).to eql(vector)
        expect(V.empty.concat(vector)).to eql(vector)
      end

      [1, 31, 32, 33, 1023, 1024, 1025].each do |size|
        context "on a #{size}-item vector" do
          it "works the same" do
            vector = V.new(1..size)
            result = vector.concat((size+1)..size+10)
            expect(result.size).to eq(size + 10)
            expect(result).to eql(V.new(1..(size+10)))
          end
        end
      end
    end
  end
end