require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  [:include?, :member?].each do |method|

    describe "##{method}" do

      describe "on a really big list" do

        before do
          @list = Hamster.interval(0, 100000)
        end

        it "doesn't run out of stack space" do
          @list.send(method, nil)
        end

      end

      [
        [[], "A", false],
        [[], nil, false],
        [["A"], "A", true],
        [["A"], "B", false],
        [["A"], nil, false],
        [["A", "B", nil], "A", true],
        [["A", "B", nil], "B", true],
        [["A", "B", nil], nil, true],
        [["A", "B", nil], "C", false],
      ].each do |values, item, expected|

        describe "on #{values.inspect}" do

          before do
            @list = Hamster.list(*values)
          end

          it "returns #{expected}" do
            @list.send(method, item).should == expected
          end

        end

      end

    end

  end

end
