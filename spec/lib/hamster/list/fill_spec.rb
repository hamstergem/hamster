require "hamster/list"

RSpec.describe Hamster::List do
  describe "#fill" do
    let(:list) { L[1, 2, 3, 4, 5, 6] }

    it "can replace a range of items at the beginning of a list" do
      expect(list.fill(:a, 0, 3)).to eql(L[:a, :a, :a, 4, 5, 6])
    end

    it "can replace a range of items in the middle of a list" do
      expect(list.fill(:a, 3, 2)).to eql(L[1, 2, 3, :a, :a, 6])
    end

    it "can replace a range of items at the end of a list" do
      expect(list.fill(:a, 4, 2)).to eql(L[1, 2, 3, 4, :a, :a])
    end

    it "can replace all the items in a list" do
      expect(list.fill(:a, 0, 6)).to eql(L[:a, :a, :a, :a, :a, :a])
    end

    it "can fill past the end of the list" do
      expect(list.fill(:a, 3, 6)).to eql(L[1, 2, 3, :a, :a, :a, :a, :a, :a])
    end

    context "with 1 argument" do
      it "replaces all the items in the list by default" do
        expect(list.fill(:a)).to eql(L[:a, :a, :a, :a, :a, :a])
      end
    end

    context "with 2 arguments" do
      it "replaces up to the end of the list by default" do
        expect(list.fill(:a, 4)).to eql(L[1, 2, 3, 4, :a, :a])
      end
    end

    context "when index and length are 0" do
      it "leaves the list unmodified" do
        expect(list.fill(:a, 0, 0)).to eql(list)
      end
    end

    it "is lazy" do
      expect { Hamster.stream { fail }.fill(:a, 0, 1) }.not_to raise_error
    end
  end
end
