require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  describe "#each" do
    describe "with no block" do
      let(:vector) { V["A", "B", "C"] }

      it "returns an Enumerator" do
        expect(vector.each.class).to be(Enumerator)
        expect(vector.each.to_a).to eq(vector)
      end
    end

    [31, 32, 33, 1023, 1024, 1025].each do |size|
      context "on a #{size}-item vector" do
        describe "with a block" do
          let(:vector) { V.new(1..size) }

          it "returns self" do
            items = []
            expect(vector.each { |item| items << item }).to be(vector)
          end

          it "yields all the items" do
            items = []
            vector.each { |item| items << item }
            expect(items).to eq((1..size).to_a)
          end

          it "iterates over the items in order" do
            expect(vector.each.first).to eq(1)
            expect(vector.each.to_a.last).to eq(size)
          end
        end
      end
    end

    context "on an empty vector" do
      it "doesn't yield anything" do
        V.empty.each { fail }
      end
    end
  end
end