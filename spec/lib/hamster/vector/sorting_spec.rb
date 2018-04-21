require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  [
    [:sort, ->(left, right) { left.length <=> right.length }],
    [:sort_by, ->(item) { item.length }],
  ].each do |method, comparator|
    describe "##{method}" do
      [
        [[], []],
        [["A"], ["A"]],
        [%w[Ichi Ni San], %w[Ni San Ichi]],
      ].each do |values, expected|
        describe "on #{values.inspect}" do
          let(:vector) { V[*values] }

          context "with a block" do
            it "preserves the original" do
              vector.send(method, &comparator)
              expect(vector).to eql(V[*values])
            end

            it "returns #{expected.inspect}" do
              expect(vector.send(method, &comparator)).to eql(V[*expected])
            end
          end

          context "without a block" do
            it "preserves the original" do
              vector.send(method)
              expect(vector).to eql(V[*values])
            end

            it "returns #{expected.sort.inspect}" do
              expect(vector.send(method)).to eql(V[*expected.sort])
            end
          end
        end
      end

      [10, 31, 32, 33, 1023, 1024, 1025].each do |size|
        context "on a #{size}-item vector" do
          it "behaves like Array#{method}" do
            array = size.times.map { rand(10000) }
            vector = V.new(array)
            if method == :sort
              expect(vector.sort).to eq(array.sort)
            else
              expect(vector.sort_by { |x| -x }).to eq(array.sort_by { |x| -x })
            end
          end
        end
      end
    end
  end
end