require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  [:empty?, :null?].each do |method|
    describe "##{method}" do
      [
        [[], true],
        [["A"], false],
        [%w[A B C], false],
      ].each do |values, expected|

        describe "on #{values.inspect}" do
          before do
            @vector = Hamster.vector(*values)
          end

          it "returns #{expected.inspect}" do
            @vector.send(method).should == expected
          end
        end
      end
    end
  end

  describe "empty" do
    it "returns the canonical empty vector" do
      Hamster::Vector.empty.size.should be(0)
      Hamster::Vector.empty.object_id.should be(Hamster::Vector.empty.object_id)
    end
  end
end