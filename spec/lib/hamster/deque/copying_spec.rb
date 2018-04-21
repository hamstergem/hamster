require "spec_helper"
require "hamster/deque"

describe Hamster::Deque do
  [:dup, :clone].each do |method|
    [
      [],
      ["A"],
      %w[A B C],
    ].each do |values|
      context "on #{values.inspect}" do
        let(:deque) { D[*values] }

        it "returns self" do
          expect(deque.send(method)).to equal(deque)
        end
      end
    end
  end
end