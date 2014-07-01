require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  let(:hash) { Hamster.hash(values) }

  [:all?, :forall?].each do |method|
    describe "##{method}" do
      context "when empty" do
        let(:values) { Hash.new }

        context "without a block" do
          it "returns true" do
            hash.send(method).should == true
          end
        end

        context "with a block" do
          it "returns true" do
            hash.send(method) { false }.should == true
          end
        end
      end

      context "when not empty" do
        let(:values) { { "A" => 1, "B" => 2, "C" => 3 } }

        context "without a block" do
          it "returns true" do
            hash.send(method).should == true
          end
        end

        context "with a block" do
          it "returns true if the block always returns true" do
            hash.send(method) { true }.should == true
          end

          it "returns false if the block ever returns false" do
            hash.send(method) { |k,v| k != 'C' }.should == false
          end
        end
      end
    end
  end
end