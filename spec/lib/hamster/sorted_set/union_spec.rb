require "spec_helper"
require "hamster/sorted_set"

describe Hamster::SortedSet do
  [:union, :|, :+, :merge].each do |method|
    describe "##{method}" do
      [
        [[], [], []],
        [["A"], [], ["A"]],
        [["A"], ["A"], ["A"]],
        [%w[A B C], [], %w[A B C]],
        [%w[A C E G X], %w[B C D E H M], %w[A B C D E G H M X]]
      ].each do |a, b, expected|
        context "for #{a.inspect} and #{b.inspect}" do
          it "returns #{expected.inspect}" do
            expect(SS[*a].send(method, SS[*b])).to eql(SS[*expected])
          end
        end

        context "for #{b.inspect} and #{a.inspect}" do
          it "returns #{expected.inspect}" do
            expect(SS[*b].send(method, SS[*a])).to eql(SS[*expected])
          end
        end
      end
    end
  end

  describe :union do
    it "filters out duplicates when passed an Array" do
      sorted_set = SS['A', 'B', 'C', 'D'].union(['A', 'A', 'A', 'C', 'A', 'B', 'E'])
      expect(sorted_set.to_a).to eq(['A', 'B', 'C', 'D', 'E'])
    end

    it "doesn't mutate an Array which is passed in" do
      array = [3,2,1,3]
      sorted_set = SS[1,2,5].union(array)
      expect(array).to eq([3,2,1,3])
    end

    context "on a set ordered by a comparator" do
      # Completely different code is executed when #union is called on a SS
      #   with a comparator block, so we should repeat all the same tests

      it "still filters out duplicates when passed an Array" do
        sorted_set = SS.new([1,2,3]) { |x,y| (x%7) <=> (y%7) }
        sorted_set = sorted_set.union([7,8,9])
        expect(sorted_set.to_a).to eq([7,1,2,3])
      end

      it "still doesn't mutate an Array which is passed in" do
        array = [3,2,1,3]
        sorted_set = SS.new([1,2,5]) { |x,y| y <=> x }
        sorted_set = sorted_set.union(array)
        expect(array).to eq([3,2,1,3])
      end
    end
  end
end