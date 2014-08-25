require "spec_helper"
require "hamster/stack"

describe Hamster::Stack do
  describe "modification (using #push, #pop)" do
    it "works when applied in many random combinations" do
      array = [1,2,3]
      stack = Hamster::Stack.new(array)
      1000.times do
        case [:push, :pop].sample
        when :push
          value = rand(10000)
          array.push(value)
          stack = stack.push(value)
        when :pop
          array.pop
          stack = stack.pop
        end

        stack.to_a.should eql(array)
        stack.size.should == array.size
      end
    end
  end
end