require "spec_helper"
require "hamster/deque"

describe Hamster::Deque do
  describe "modification (using #push, #pop, #shift, and #unshift)" do
    it "works when applied in many random combinations" do
      array = [1,2,3]
      deque = Hamster::Deque.new(array)
      1000.times do
        case [:push, :pop, :shift, :unshift].sample
        when :push
          value = rand(10000)
          array.push(value)
          deque = deque.push(value)
        when :pop
          array.pop
          deque = deque.pop
        when :shift
          array.shift
          deque = deque.shift
        when :unshift
          value = rand(10000)
          array.unshift(value)
          deque = deque.unshift(value)
        end

        expect(deque.to_a).to eql(array)
        expect(deque.size).to eq(array.size)
        expect(deque.first).to eq(array.first)
        expect(deque.last).to eq(array.last)
      end
    end
  end
end