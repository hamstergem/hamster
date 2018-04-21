require "hamster/list"

describe Hamster::List do
  describe "#rotate" do
    let(:list) { L[1,2,3,4,5] }

    context "when passed no argument" do
      it "returns a new list with the first element moved to the end" do
        expect(list.rotate).to eql(L[2,3,4,5,1])
      end
    end

    context "with an integral argument n" do
      it "returns a new list with the first (n % size) elements moved to the end" do
        expect(list.rotate(2)).to eql(L[3,4,5,1,2])
        expect(list.rotate(3)).to eql(L[4,5,1,2,3])
        expect(list.rotate(4)).to eql(L[5,1,2,3,4])
        expect(list.rotate(5)).to eql(L[1,2,3,4,5])
        expect(list.rotate(-1)).to eql(L[5,1,2,3,4])
      end
    end

    context "with a non-numeric argument" do
      it "raises a TypeError" do
        expect { list.rotate('hello') }.to raise_error(TypeError)
      end
    end

    context "with an argument of zero (or one evenly divisible by list length)" do
      it "it returns self" do
        expect(list.rotate(0)).to be(list)
        expect(list.rotate(5)).to be(list)
      end
    end
  end
end
