require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  [
    [:sort, lambda { |left, right| left.length <=> right.length }],
    [:sort_by, lambda { |item| item.length }],
  ].each do |method, comparator|

    describe "##{method}" do

      describe "doesn't run out of stack space on a really big" do

        it "stream" do
          @list = Hamster.interval(0, STACK_OVERFLOW_DEPTH)
        end

        it "list" do
          @list = (0...STACK_OVERFLOW_DEPTH).reduce(Hamster.list) { |list, i| list.cons(i) }
        end

        after do
          @list.send(method)
        end

      end

      [
        [[], []],
        [["A"], ["A"]],
        [["Ichi", "Ni", "San"], ["Ni", "San", "Ichi"]],
      ].each do |values, expected|

        describe "on #{values.inspect}" do

          before do
            @original = Hamster.list(*values)
          end

          describe "with a block" do

            before do
              @result = @original.send(method, &comparator)
            end

            it "preserves the original" do
              @original.should == Hamster.list(*values)
            end

            it "returns #{expected.inspect}" do
              @result.should == Hamster.list(*expected)
            end

          end

          describe "without a block" do

            before do
              @result = @original.send(method)
            end

            it "preserves the original" do
              @original.should == Hamster.list(*values)
            end

            it "returns #{expected.sort.inspect}" do
              @result.should == Hamster.list(*expected.sort)
            end

          end

        end

      end

    end

  end

end
