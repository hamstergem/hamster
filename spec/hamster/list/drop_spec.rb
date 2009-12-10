require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#drop" do

    describe "on a really big list" do

      before do
        @list = Hamster.interval(0, 100000)
      end

      it "doesn't run out of stack space" do
        @list.drop(100000)
      end

    end

    [
      [[], 10, []],
      [["A"], 10, []],
      [["A"], -1, ["A"]],
      [["A", "B", "C"], 0, ["A", "B", "C"]],
      [["A", "B", "C"], 2, ["C"]],
    ].each do |values, number, expected|

      describe "#{number} from #{values.inspect}" do

        before do
          @list = Hamster.list(*values)
        end

        it "returns #{expected}" do
          @list.drop(number).should == Hamster.list(*expected)
        end

      end

    end

  end

end
