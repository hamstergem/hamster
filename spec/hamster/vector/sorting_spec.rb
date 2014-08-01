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
          before do
            @original = Hamster.vector(*values)
          end

          context "with a block" do
            before do
              @result = @original.send(method, &comparator)
            end

            it "preserves the original" do
              @original.should eql(Hamster.vector(*values))
            end

            it "returns #{expected.inspect}" do
              @result.should eql(Hamster.vector(*expected))
            end
          end

          context "without a block" do
            before do
              @result = @original.send(method)
            end

            it "preserves the original" do
              @original.should eql(Hamster.vector(*values))
            end

            it "returns #{expected.sort.inspect}" do
              @result.should eql(Hamster.vector(*expected.sort))
            end
          end
        end
      end
    end
  end
end