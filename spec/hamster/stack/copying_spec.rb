require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Stack do

  before do
    @stack = Hamster.stack.push("A").push("B").push("C")
  end

  [:dup, :clone].each do |method|

    describe "##{method}" do

      it "returns self" do
        @stack.send(method).should equal(@stack)
      end

    end

  end

end
