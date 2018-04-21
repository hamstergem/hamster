require "spec_helper"
require "hamster/set"

describe Hamster::Set do
  [:find, :detect].each do |method|
    describe "##{method}" do
      [
        [[], "A", nil],
        [[], nil, nil],
        [["A"], "A", "A"],
        [["A"], "B", nil],
        [["A"], nil, nil],
        [["A", "B", nil], "A", "A"],
        [["A", "B", nil], "B", "B"],
        [["A", "B", nil], nil, nil],
        [["A", "B", nil], "C", nil],
      ].each do |values, item, expected|
        describe "on #{values.inspect}" do
          context "with a block" do
            it "returns #{expected.inspect}" do
              expect(S[*values].send(method) { |x| x == item }).to eq(expected)
            end
          end

          context "without a block" do
            it "returns an Enumerator" do
              result = S[*values].send(method)
              expect(result.class).to be(Enumerator)
              expect(result.each { |x| x == item}).to eq(expected)
            end
          end
        end
      end
    end
  end
end