require "spec_helper"
require "hamster/stack"
require "hamster/list"

describe Hamster::Stack do
  describe "#to_list" do
    [
      [[], []],
      [["A"], ["A"]],
      [%w[A B C], %w[C B A]],
    ].each do |values, expected|
      context "on #{values.inspect}" do
        it "returns #{expected.inspect}" do
          Hamster.stack(*values).to_list.should eql(Hamster.list(*expected))
        end
      end
    end
  end
end