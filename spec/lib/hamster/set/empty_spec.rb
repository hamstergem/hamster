require "spec_helper"
require "hamster/set"

describe Hamster::Set do
  [:empty?, :null?].each do |method|
    describe "##{method}" do
      [
        [[], true],
        [["A"], false],
        [%w[A B C], false],
      ].each do |values, expected|

        describe "on #{values.inspect}" do
          before do
            @set = Hamster.set(*values)
          end

          it "returns #{expected.inspect}" do
            @set.send(method).should == expected
          end
        end
      end
    end
  end

  describe "empty" do
    it "returns the canonical empty set" do
      Hamster::Set.empty.size.should be(0)
      Hamster::Set.empty.object_id.should be(Hamster::Set.empty.object_id)
    end

    context "from a subclass" do
      it "returns an empty instance of the subclass" do
        subclass = Class.new(Hamster::Set)
        subclass.empty.class.should be(subclass)
        subclass.empty.should be_empty
      end
    end
  end
end