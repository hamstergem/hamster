require "spec_helper"

require "hamster/list"

describe Hamster::List do

  describe "#to_ary" do

    describe "on a really big list" do

      before do
        @list = Hamster.interval(0, STACK_OVERFLOW_DEPTH)
      end

      it "doesn't run out of stack" do
        -> { @list.to_ary }.should_not raise_error
      end

    end

    describe "enables implicit conversion to" do

      before do
        @list = Hamster.list("A", "B", "C", "D")
      end

      it "block parameters" do
        def func(&block)
          yield(@list)
        end
        func do |a, b, *c|
          a.should == "A"
          b.should == "B"
          c.should == %w[C D]
        end
      end

      it "method arguments" do
        def func(a, b, *c)
          a.should == "A"
          b.should == "B"
          c.should == %w[C D]
        end
        func(*@list)
      end

      it "works with splat" do
        array = *@list
        array.should == %w[A B C D]
      end

    end

  end

end
