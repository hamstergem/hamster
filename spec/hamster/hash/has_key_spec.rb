require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Hash do

  [:has_key?, :key?, :include?, :member?].each do |method|

    describe "#has_key?" do

      before do
        @hash = Hamster.hash("A" => "aye", "B" => "bee", "C" => "see", nil => "NIL")
      end

      ["A", "B", "C", nil].each do |key|

        it "returns true for an existing key (#{key.inspect})" do
          @hash.send(method, key).should be_true
        end

      end

      it "returns false for a non-existing key" do
        @hash.send(method, "D").should be_false
      end

    end

  end

end
