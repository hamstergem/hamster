require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  before do
    @hash = Hamster.hash(toast: 'buttered', jam: 'strawberry')
  end

  [:value?, :has_value?].each do |method|
    describe "##{method}" do
      it "returns true if any key/val pair in Hash has the same value" do
        @hash.send(method, 'strawberry').should == true
      end

      it "returns false if no key/val pair in Hash has the same value" do
        @hash.send(method, 'marmalade').should == false
      end

      it "uses #== to check equality" do
        Hamster.hash(a: EqualNotEql.new).send(method, EqualNotEql.new).should == true
        Hamster.hash(a: EqlNotEqual.new).send(method, EqlNotEqual.new).should == false
      end
    end
  end
end