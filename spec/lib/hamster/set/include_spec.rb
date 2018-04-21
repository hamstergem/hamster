require "hamster/set"
require 'set'

describe Hamster::Set do
  [:include?, :member?].each do |method|
    describe "##{method}" do
      let(:set) { S["A", "B", "C", 2.0, nil] }

      ["A", "B", "C", 2.0, nil].each do |value|
        it "returns true for an existing value (#{value.inspect})" do
          expect(set.send(method, value)).to eq(true)
        end
      end

      it "returns false for a non-existing value" do
        expect(set.send(method, "D")).to eq(false)
      end

      it "returns true even if existing value is nil" do
        expect(S[nil].include?(nil)).to eq(true)
      end

      it "returns true even if existing value is false" do
        expect(S[false].include?(false)).to eq(true)
      end

      it "returns false for a mutable item which is mutated after adding" do
        item = ['mutable']
        item = [rand(1000000)] while (item.hash.abs & 31 == [item[0], 'HOSED!'].hash.abs & 31)
        set  = S[item]
        item.push('HOSED!')
        expect(set.include?(item)).to eq(false)
      end

      it "uses #eql? for equality" do
        expect(set.send(method, 2)).to eq(false)
      end

      it "returns the right answers after a lot of addings and removings" do
        array, set, rb_set = [], S.new, ::Set.new

        1000.times do
          if rand(2) == 0
            array << (item = rand(10000))
            rb_set.add(item)
            set = set.add(item)
            expect(set.include?(item)).to eq(true)
          else
            item = array.sample
            rb_set.delete(item)
            set = set.delete(item)
            expect(set.include?(item)).to eq(false)
          end
        end

        array.each { |item| expect(set.include?(item)).to eq(rb_set.include?(item)) }
      end
    end
  end
end
