require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  describe "#zip" do

    describe "doesn't run out of stack space on a really big" do

      it "stream" do
        @a = @b = Hamster.interval(0, 10000)
      end

      it "list" do
        @a = @b = (0..10000).reduce(Hamster.list) { |list, i| list.cons(i) }
      end

      after do
        @a.zip(@b)
      end

    end

    it "is lazy" do
      count = 0
      left = Hamster.stream { count += 1 }
      right = Hamster.stream { count += 1 }
      result = left.zip(right)
      count.should <= 2
    end

    [
      [[], [], []],
      [["A"], ["aye"], [Hamster.list("A", "aye")]],
      [["A"], [], [Hamster.list("A", nil)]],
      [[], ["A"], [Hamster.list(nil, "A")]],
      [["A", "B", "C"], ["aye", "bee", "see"], [Hamster.list("A", "aye"), Hamster.list("B", "bee"), Hamster.list("C", "see")]],
    ].each do |left, right, expected|

      describe "on #{left.inspect} and #{right.inspect}" do

        before do
          @left = Hamster.list(*left)
          @right = Hamster.list(*right)
          @result = @left.zip(@right)
        end

        it "returns #{expected.inspect}" do
          @result.should == Hamster.list(*expected)
        end

      end

    end

  end

end
