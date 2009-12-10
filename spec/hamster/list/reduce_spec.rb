require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  [:reduce, :inject].each do |method|

    describe "##{method}" do

      describe "on a really big list" do

        before do
          @list = Hamster.interval(0, 100000)
        end

        it "doesn't run out of stack space" do
          @list.reduce(nil) { }
        end

      end

      [
        [[], "@"],
        [["A"], "@a"],
        [["A", "B", "C"], "@abc"],
      ].each do |values, expected|

        describe "on #{values.inspect}" do

          before do
            @list = Hamster.list(*values)
          end

          describe "with a block" do

            it "returns #{expected.inspect}" do
              @list.send(method, "@") { |memo, item| memo << item.downcase }.should == expected
            end

          end

          describe "without a block" do

            it "returns the memo" do
              @list.send(method, "@").should == "@"
            end

          end

        end

      end

    end

  end

end
