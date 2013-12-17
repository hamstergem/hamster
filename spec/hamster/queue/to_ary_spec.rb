require "spec_helper"

require "hamster/queue"

describe Hamster::Queue do

  describe "#to_ary" do

    describe "enables implicit conversion to" do

      before do
        @queue = Hamster.queue("A", "B", "C", "D")
      end

      it "block parameters" do
        def func(&block)
          yield(@queue)
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
        func(*@queue)
      end

      it "works with splat" do
        array = *@queue
        array.should == %w[A B C D]
      end

    end

  end

end
