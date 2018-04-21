require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  [:select, :find_all].each do |method|
    describe "##{method}" do
      let(:vector) { V["A", "B", "C"] }

      describe "with a block" do
        it "preserves the original" do
          vector.send(method) { |item| item == "A" }
          expect(vector).to eql(V["A", "B", "C"])
        end

        it "returns a vector with the matching values" do
          expect(vector.send(method) { |item| item == "A" }).to eql(V["A"])
        end
      end

      describe "with no block" do
        it "returns an Enumerator" do
          expect(vector.send(method).class).to be(Enumerator)
          expect(vector.send(method).each { |item| item == "A" }).to eql(V["A"])
        end
      end

      describe "when nothing matches" do
        it "preserves the original" do
          vector.send(method) { |item| false }
          expect(vector).to eql(V["A", "B", "C"])
        end

        it "returns an empty vector" do
          expect(vector.send(method) { |item| false }).to equal(V.empty)
        end
      end

      context "on an empty vector" do
        it "returns self" do
          expect(V.empty.send(method) { |item| true }).to be(V.empty)
        end
      end

      context "from a subclass" do
        it "returns an instance of the subclass" do
          subclass = Class.new(Hamster::Vector)
          instance = subclass[1,2,3]
          expect(instance.send(method) { |x| x > 1 }.class).to be(subclass)
        end
      end

      it "works with a variety of inputs" do
        [1, 2, 10, 31, 32, 33, 1023, 1024, 1025].each do |size|
          [0, 5, 32, 50, 500, 800, 1024].each do |threshold|
            vector = V.new(1..size)
            result = vector.send(method) { |item| item <= threshold }
            expect(result.size).to eq([size, threshold].min)
            expect(result).to eql(V.new(1..[size, threshold].min))
          end
        end
      end
    end
  end
end