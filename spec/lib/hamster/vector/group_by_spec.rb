require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  describe "#group_by" do
    context "with a block" do
      [
        [[], []],
        [[1], [true => V[1]]],
        [[1, 2, 3, 4], [true => V[1, 3], false => V[2, 4]]],
      ].each do |values, expected|
        context "on #{values.inspect}" do
          let(:vector) { V[*values] }

          it "returns #{expected.inspect}" do
            expect(vector.group_by(&:odd?)).to eql(H[*expected])
            expect(vector).to eql(V.new(values)) # make sure it hasn't changed
          end
        end
      end
    end

    context "without a block" do
      [
        [[], []],
        [[1], [1 => V[1]]],
        [[1, 2, 3, 4], [1 => V[1], 2 => V[2], 3 => V[3], 4 => V[4]]],
      ].each do |values, expected|
        context "on #{values.inspect}" do
          let(:vector) { V[*values] }

          it "returns #{expected.inspect}" do
            expect(vector.group_by).to eql(H[*expected])
            expect(vector).to eql(V.new(values)) # make sure it hasn't changed
          end
        end
      end
    end

    context "on an empty vector" do
      it "returns an empty hash" do
        expect(V.empty.group_by { |x| x }).to eql(H.empty)
      end
    end

    it "returns a hash without default proc" do
      expect(V[1,2,3].group_by { |x| x }.default_proc).to be_nil
    end

    context "from a subclass" do
      it "returns an Hash whose values are instances of the subclass" do
        subclass = Class.new(Hamster::Vector)
        instance = subclass.new([1, 'string', :symbol])
        instance.group_by { |x| x.class }.values.each { |v| expect(v.class).to be(subclass) }
      end
    end
  end
end