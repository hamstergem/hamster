require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  [:merge, :+].each do |method|
    describe "##{method}" do
      [
        [[], [], []],
        [["A" => "aye"], [], ["A" => "aye"]],
        [["A" => "aye"], ["A" => "bee"], ["A" => "bee"]],
        [["A" => "aye"], ["B" => "bee"], ["A" => "aye", "B" => "bee"]],
      ].each do |a, b, expected|

        describe "for #{a.inspect} and #{b.inspect}" do
          before do
            @result = Hamster.hash(*a).send(method, Hamster.hash(*b))
          end

          it "returns #{expected.inspect} when passed a Hamster::Hash"  do
            @result.should == Hamster.hash(*expected)
          end

          it "returns #{expected.inspect} when passed a Ruby Hash" do
            Hamster.hash(*a).send(method, Hash[*b]).should == Hamster.hash(*expected)
          end
        end
      end
    end

    context "when merging with an empty Hash" do
      it "returns self" do
        @hash = Hamster.hash(a: 1, b: 2)
        @hash.merge(Hamster.hash).should be(@hash)
      end
    end
  end
end