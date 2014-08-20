require "spec_helper"
require "hamster/list"

describe Hamster::List do
  [:slice, :[]].each do |method|
    describe "#slice" do
      it "is lazy" do
        -> { Hamster.stream { fail }.send(method, 1, 5) }.should_not raise_error
      end

      [
        [[], 0, 10, []],
        [[], 1, 1, []],
        [["A"], 0, 0, []],
        [["A"], 1, 1, []],
        [["A"], 1, 10, []],
        [["A"], 0, 1, ["A"]],
        [["A"], 0, 10, ["A"]],
        [%w[A B C], 0, 3, %w[A B C]],
        [%w[A B C], 2, 1, ["C"]],
      ].each do |values, from, length, expected|
        context "on #{values.inspect} from #{from} for a length of #{length}" do
          let(:list) { Hamster.list(*values) }

          it "preserves the original" do
            list.send(method, from, length)
            list.should eql(Hamster.list(*values))
          end

          it "returns #{expected.inspect}" do
            list.send(method, from, length).should eql(Hamster.list(*expected))
          end
        end
      end
    end
  end
end