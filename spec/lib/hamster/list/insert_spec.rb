require "spec_helper"
require "hamster/list"

describe Hamster::List do
  describe "#insert" do
    let(:original) { L[1, 2, 3] }

    it "can add items at the beginning of a list" do
      list = original.insert(0, :a, :b)
      expect(list.size).to be(5)
      expect(list.at(0)).to be(:a)
      expect(list.at(2)).to be(1)
    end

    it "can add items in the middle of a list" do
      list = original.insert(1, :a, :b, :c)
      expect(list.size).to be(6)
      expect(list.to_a).to eq([1, :a, :b, :c, 2, 3])
    end

    it "can add items at the end of a list" do
      list = original.insert(3, :a, :b, :c)
      expect(list.size).to be(6)
      expect(list.to_a).to eq([1, 2, 3, :a, :b, :c])
    end

    it "can add items past the end of a list" do
      list = original.insert(6, :a, :b)
      expect(list.size).to be(8)
      expect(list.to_a).to eq([1, 2, 3, nil, nil, nil, :a, :b])
    end

    it "accepts a negative index, which counts back from the end of the list" do
      list = original.insert(-2, :a)
      expect(list.size).to be(4)
      expect(list.to_a).to eq([1, :a, 2, 3])
    end

    it "raises IndexError if a negative index is too great" do
      expect { original.insert(-4, :a) }.to raise_error(IndexError)
    end

    it "is lazy" do
      expect { Hamster.stream { fail }.insert(0, :a) }.not_to raise_error
    end
  end
end