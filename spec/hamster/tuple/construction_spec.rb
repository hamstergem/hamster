require "spec_helper"
require "hamster/tuple"

describe Hamster do
  describe ".tuple" do
    context "with no arguments" do
      let(:tuple) { Hamster.tuple }

      it "returns an empty tuple" do
        expect(tuple).to be_empty
      end
    end

    context "with a number of items" do
      let(:tuple) { Hamster.tuple("A", "B", "C") }

      it "is the same as constructing a new Tuple directly" do
        expect(tuple).to eq(Hamster::Tuple.new(["A", "B", "C"]))
      end
    end
  end

  describe "[]" do
    context "with no arguments" do
      let(:tuple) { Hamster::Tuple[] }

      it "returns an empty tuple" do
        expect(tuple).to be_empty
      end
    end

    context "with a number of items" do
      let(:tuple) { Hamster::Tuple["A", "B", "C"] }

      it "same as constructing a new Tuple directly" do
        expect(tuple).to eq(Hamster::Tuple.new(["A", "B", "C"]))
      end
    end
  end
end
