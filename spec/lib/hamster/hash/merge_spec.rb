require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  [:merge, :+].each do |method|
    describe "##{method}" do
      [
        [[], [], []],
        [["A" => "aye"], [], ["A" => "aye"]],
        [["A" => "aye"], ["A" => "bee"], ["A" => "bee"]],
        [["A" => "aye"], ["B" => "bee"], ["A" => "aye", "B" => "bee"]],
      ].each do |a, b, expected|

        describe "for #{a.inspect} and #{b.inspect}" do
          before do
            @result = Hamster.hash(*a).send(method, Hamster.hash(*b))
          end

          it "returns #{expected.inspect} when passed a Hamster::Hash"  do
            @result.should == Hamster.hash(*expected)
          end

          it "returns #{expected.inspect} when passed a Ruby Hash" do
            Hamster.hash(*a).send(method, Hash[*b]).should == Hamster.hash(*expected)
          end
        end
      end
    end

    context "when merging with an empty Hash" do
      it "returns self" do
        @hash = Hamster.hash(a: 1, b: 2)
        @hash.merge(Hamster.hash).should be(@hash)
      end
    end

    it "sets any duplicate key to the value of block if passed a block" do
      h1 = Hamster.hash(:a => 2, :b => 1, :d => 5)
      h2 = Hamster.hash(:a => -2, :b => 4, :c => -3)
      r = h1.merge(h2) { |k,x,y| nil }
      r.should eql(Hamster.hash(:a => nil, :b => nil, :c => -3, :d => 5))

      r = h1.merge(h2) { |k,x,y| "#{k}:#{x+2*y}" }
      r.should eql(Hamster.hash(:a => "a:-2", :b => "b:9", :c => -3, :d => 5))

      lambda {
        h1.merge(h2) { |k, x, y| raise(IndexError) }
      }.should raise_error(IndexError)

      r = h1.merge(h1) { |k,x,y| :x }
      r.should eql(Hamster.hash(:a => :x, :b => :x, :d => :x))
    end
  end
end