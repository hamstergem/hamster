require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Set do

  [:include?, :member?].each do |method|

    describe "##{method}" do

      before do
        @set = Hamster.set("A", "B", "C", nil)
      end

      ["A", "B", "C", nil].each do |value|

        it "returns true for an existing value (#{value.inspect})" do
          @set.send(method, value).should be_true
        end

      end

      it "returns false for a non-existing value" do
        @set.send(method, "D").should be_false
      end

    end

  end

end
