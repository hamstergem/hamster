require "spec_helper"
require "hamster/list"

describe Hamster::List do
  context "without a comparator" do
    context "on an empty list" do
      subject { L.empty }

      it "returns an empty list" do
        expect(subject.merge).to be_empty
      end
    end

    context "on a single list" do
      let(:list) { L[1, 2, 3] }

      subject { L[list] }

      it "returns the list" do
        expect(subject.merge).to eq(list)
      end
    end

    context "with multiple lists" do
      subject { L[L[3, 6, 7, 8], L[1, 2, 4, 5, 9]] }

      it "merges the lists based on natural sort order" do
        expect(subject.merge).to eq(L[1, 2, 3, 4, 5, 6, 7, 8, 9])
      end
    end
  end

  context "with a comparator" do
    context "on an empty list" do
      subject { L.empty }

      it "returns an empty list" do
        expect(subject.merge { |a, b| fail("should never be called") }).to be_empty
      end
    end

    context "on a single list" do
      let(:list) { L[1, 2, 3] }

      subject { L[list] }

      it "returns the list" do
        expect(subject.merge { |a, b| fail("should never be called") }).to eq(list)
      end
    end

    context "with multiple lists" do
      subject { L[L[8, 7, 6, 3], L[9, 5, 4, 2, 1]] }

      it "merges the lists based on the specified comparator" do
        expect(subject.merge { |a, b| b <=> a }).to eq(L[9, 8, 7, 6, 5, 4, 3, 2, 1])
      end
    end
  end
end