require "hamster/vector"

describe Hamster::Vector do
  describe "#fetch" do
    let(:vector) { V['a', 'b', 'c'] }

    context "with no default provided" do
      context "when the index exists" do
        it "returns the value at the index" do
          expect(vector.fetch(0)).to eq("a")
          expect(vector.fetch(1)).to eq("b")
          expect(vector.fetch(2)).to eq("c")
        end
      end

      context "when the key does not exist" do
        it "raises an IndexError" do
          expect { vector.fetch(3) }.to raise_error(IndexError)
          expect { vector.fetch(-4) }.to raise_error(IndexError)
        end
      end
    end

    context "with a default value" do
      context "when the index exists" do
        it "returns the value at the index" do
          expect(vector.fetch(0, "default")).to eq("a")
          expect(vector.fetch(1, "default")).to eq("b")
          expect(vector.fetch(2, "default")).to eq("c")
        end
      end

      context "when the index does not exist" do
        it "returns the default value" do
          expect(vector.fetch(3, "default")).to eq("default")
          expect(vector.fetch(-4, "default")).to eq("default")
        end
      end
    end

    context "with a default block" do
      context "when the index exists" do
        it "returns the value at the index" do
          expect(vector.fetch(0) { "default".upcase }).to eq("a")
          expect(vector.fetch(1) { "default".upcase }).to eq("b")
          expect(vector.fetch(2) { "default".upcase }).to eq("c")
        end
      end

      context "when the index does not exist" do
        it "invokes the block with the missing index as parameter" do
          vector.fetch(3) { |index| expect(index).to eq(3)}
          vector.fetch(-4) { |index| expect(index).to eq(-4) }
          expect(vector.fetch(3) { "default".upcase }).to eq("DEFAULT")
          expect(vector.fetch(-4) { "default".upcase }).to eq("DEFAULT")
        end
      end
    end

    it "gives precedence to default block over default argument if passed both" do
      expect(vector.fetch(3, 'one') { 'two' }).to eq('two')
    end
  end
end
