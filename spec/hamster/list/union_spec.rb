require File.expand_path('../../spec_helper', File.dirname(__FILE__))

require 'hamster/list'

describe Hamster::List do

  [:union, :|].each do |method|

    describe "#union" do

      it "is lazy" do
        lambda { Hamster.stream { fail }.union(Hamster.stream { fail }) }.should_not raise_error
      end

      [
        [[], [], []],
        [["A"], [], ["A"]],
        [["A", "B", "C"], [], ["A", "B", "C"]],
        [["A", "A"], ["A"], ["A"]],
      ].each do |a, b, expected|

        describe "returns #{expected.inspect}" do

          before do
            @a = Hamster.list(*a)
            @b = Hamster.list(*b)
          end

          it "for #{a.inspect} and #{b.inspect}"  do
            @result = @a.send(method, @b)
          end

          it "for #{b.inspect} and #{a.inspect}"  do
            @result = @b.send(method, @a)
          end

          after  do
            @result.should == Hamster.list(*expected)
          end

        end

      end

    end

  end

end
