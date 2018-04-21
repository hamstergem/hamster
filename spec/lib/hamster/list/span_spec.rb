require "spec_helper"
require "hamster/list"

describe "Hamster::list#span" do
  it "is lazy" do
    expect { Hamster.stream { |item| fail }.span { true } }.not_to raise_error
  end

  describe <<-DESC do
given a predicate (in the form of a block), splits the list into two lists
  (returned as an array) such that elements in the first list (the prefix) are
  taken from the head of the list while the predicate is satisfied, and elements
  in the second list (the remainder) are the remaining elements from the list
  once the predicate is not satisfied. For example:
DESC

    [
      [[], [], []],
      [[1], [1], []],
      [[1, 2], [1, 2], []],
      [[1, 2, 3], [1, 2], [3]],
      [[1, 2, 3, 4], [1, 2], [3, 4]],
      [[2, 3, 4], [2], [3, 4]],
      [[3, 4], [], [3, 4]],
      [[4], [], [4]],
    ].each do |values, expected_prefix, expected_remainder|
      context "given the list #{values.inspect}" do
        let(:list) { L[*values] }

        context "and a predicate that returns true for values <= 2" do
          let(:result) { list.span { |item| item <= 2 }}
          let(:prefix) { result.first }
          let(:remainder) { result.last }

          it "preserves the original" do
            result
            expect(list).to eql(L[*values])
          end

          it "returns the prefix as #{expected_prefix.inspect}" do
            expect(prefix).to eql(L[*expected_prefix])
          end

          it "returns the remainder as #{expected_remainder.inspect}" do
            expect(remainder).to eql(L[*expected_remainder])
          end

          it "calls the block only once for each element" do
            count = 0
            result = list.span { |item| count += 1; item <= 2 }
            # force realization of lazy lists
            expect(result.first.size).to eq(expected_prefix.size)
            expect(result.last.size).to eq(expected_remainder.size)
            # it may not need to call the block on every element, just up to the
            # point where the block first returns a false value
            expect(count).to be <= values.size
          end
        end

        context "without a predicate" do
          it "returns a frozen array" do
            expect(list.span.class).to be(Array)
            expect(list.span).to be_frozen
          end

          it "returns self as the prefix" do
            expect(list.span.first).to equal(list)
          end

          it "returns an empty list as the remainder" do
            expect(list.span.last).to be_empty
          end
        end
      end
    end
  end
end