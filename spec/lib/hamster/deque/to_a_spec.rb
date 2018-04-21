require "spec_helper"
require "hamster/deque"

describe Hamster::Deque do
  [:to_a, :entries].each do |method|
    describe "##{method}" do
      [
        [],
        ["A"],
        %w[A B C],
      ].each do |values|
        context "on #{values.inspect}" do
          it "returns #{values.inspect}" do
            expect(D[*values].send(method)).to eq(values)
          end

          it "returns a mutable array" do
            result = D[*values].send(method)
            expect(result.last).to_not eq("The End")
            result << "The End"
            expect(result.last).to eq("The End")
          end
        end
      end
    end
  end
end