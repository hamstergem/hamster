require "spec_helper"
require "hamster/queue"

describe Hamster::Queue do
  describe "modification (using #push, #pop, #shift, and #unshift)" do
    it "works when applied in many random combinations" do
      array = [1,2,3]
      queue = Hamster::Queue.new(array)
      1000.times do
        case [:push, :pop, :shift, :unshift].sample
        when :push
          value = rand(10000)
          array.push(value)
          queue = queue.push(value)
        when :pop
          array.pop
          queue = queue.pop
        when :shift
          array.shift
          queue = queue.shift
        when :unshift
          value = rand(10000)
          array.unshift(value)
          queue = queue.unshift(value)
        end

        queue.to_a.should eql(array)
        queue.size.should == array.size
        queue.first.should == array.first
        queue.last.should == array.last
      end
    end
  end
end