require 'spec_helper'

require 'hamster/hash'

describe Hamster::Hash do

  [:size, :length].each do |method|

    describe "##{method}" do

      [
        [[], 0],
        [["A" => "aye"], 1],
        [["A" => "bee", "B" => "bee", "C" => "see"], 3],
      ].each do |values, result|

        it "returns #{result} for #{values.inspect}" do
          Hamster.hash(*values).send(method).should == result
        end

      end

      LOTS = (1..10842).to_a
      srand 89533474
      random_things = (LOTS + LOTS).sort_by{|x|rand}

      it "should have the correct size after adding lots of things with colliding keys and such" do
        h = Hamster.hash
        random_things.each do |thing|
          h = h.put(thing, thing * 2)
        end
        h.size.should == 10842
      end

      random_actions = (LOTS.map{|x|[:add, x]} + LOTS.map{|x|[:add, x]} + LOTS.map{|x|[:remove, x]}).
        sort_by{|x|rand}
      ending_size = random_actions.reduce({}) do |h, (act, ob)|
        if act == :add
          h[ob] = 1
        else
          h.delete(ob)
        end
        h
      end.size
      it "should have the correct size after lots of addings and removings" do
        h = Hamster.hash
        random_actions.each do |(act, ob)|
          if act == :add
            h = h.put(ob, ob * 3)
          else
            h = h.delete(ob)
          end
        end
        h.size.should == ending_size
      end

    end

  end

end
