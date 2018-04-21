require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  describe "#eql" do
    let(:vector) { V["A", "B", "C"] }

    it "returns false when comparing with an array with the same contents" do
      expect(vector.eql?(%w[A B C])).to eq(false)
    end

    it "returns false when comparing with an arbitrary object" do
      expect(vector.eql?(Object.new)).to eq(false)
    end

    it "returns false when comparing an empty vector with an empty array" do
      expect(V.empty.eql?([])).to eq(false)
    end

    it "returns false when comparing with a subclass of Hamster::Vector" do
      expect(vector.eql?(Class.new(Hamster::Vector).new(%w[A B C]))).to eq(false)
    end
  end

  describe "#==" do
    let(:vector) { V["A", "B", "C"] }

    it "returns true when comparing with an array with the same contents" do
      expect(vector == %w[A B C]).to eq(true)
    end

    it "returns false when comparing with an arbitrary object" do
      expect(vector == Object.new).to eq(false)
    end

    it "returns true when comparing an empty vector with an empty array" do
      expect(V.empty == []).to eq(true)
    end

    it "returns true when comparing with a subclass of Hamster::Vector" do
      expect(vector == Class.new(Hamster::Vector).new(%w[A B C])).to eq(true)
    end

    it "works on larger vectors" do
      array = 2000.times.map { rand(10000) }
      expect(V.new(array.dup) == array).to eq(true)
    end
  end

  [:eql?, :==].each do |method|
    describe "##{method}" do
      [
        [[], [], true],
        [[], [nil], false],
        [["A"], [], false],
        [["A"], ["A"], true],
        [["A"], ["B"], false],
        [%w[A B], ["A"], false],
        [%w[A B C], %w[A B C], true],
        [%w[C A B], %w[A B C], false],
      ].each do |a, b, expected|
        describe "returns #{expected.inspect}" do
          let(:vector_a) { V[*a] }
          let(:vector_b) { V[*b] }

          it "for vectors #{a.inspect} and #{b.inspect}" do
            expect(vector_a.send(method, vector_b)).to eq(expected)
          end

          it "for vectors #{b.inspect} and #{a.inspect}" do
            expect(vector_b.send(method, vector_a)).to eq(expected)
          end
        end
      end
    end
  end
end