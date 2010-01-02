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

    [
      [[], [], []],
      [["A"], ["aye"], [Hamster.list("A", "aye")]],
      [["A"], [], [Hamster.list("A", nil)]],
      [[], ["A"], [Hamster.list(nil, "A")]],
      [["A", "B", "C"], ["aye", "bee", "see"], [Hamster.list("A", "aye"), Hamster.list("B", "bee"), Hamster.list("C", "see")]],
    ].each do |a, b, expected|

      describe "on #{a.inspect} and #{b.inspect}" do

        before do
          @a = Hamster.list(*a)
          @b = Hamster.list(*b)
        end

        it "returns #{expected.inspect}" do
          @a.zip(@b).should == Hamster.list(*expected)
        end

      end

    end

  end

end
