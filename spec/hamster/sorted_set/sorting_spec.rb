require "spec_helper"
require "hamster/sorted_set"

describe Hamster::SortedSet do
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
            @original = Hamster.sorted_set(*values) { |item| item.reverse }
          end

          context "with a block" do
            before do
              @array  = @original.to_a
              @result = @original.send(method, &comparator)
            end

            it "preserves the original" do
              @original.to_a.should == @array
            end

            it "returns #{expected.inspect}" do
              @result.class.should be(Hamster::SortedSet)
              @result.to_a.should == expected
            end
          end

          context "without a block" do
            before do
              @array  = @original.to_a
              @result = @original.send(method)
            end

            it "preserves the original" do
              @original.to_a.should == @array
            end

            it "returns #{expected.sort.inspect}" do
              @result.class.should be(Hamster::SortedSet)
              @result.to_a.should == expected.sort
            end
          end
        end
      end
    end
  end
end