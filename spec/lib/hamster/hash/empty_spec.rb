require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  [:empty?, :null?].each do |method|
    describe "##{method}" do
      [
        [[], true],
        [["A" => "aye"], false],
        [["A" => "aye", "B" => "bee", "C" => "see"], false],
      ].each do |pairs, result|

        it "returns #{result} for #{pairs.inspect}" do
          Hamster.hash(*pairs).send(method).should == result
        end

        context "from a subclass" do
          it "returns an empty instance of the subclass" do
            @subclass = Class.new(Hamster::Hash)
            @subclass.empty.class.should be @subclass
            @subclass.empty.should be_empty
          end
        end
      end
    end
  end
end