require "spec_helper"
require "hamster/hash"

describe Hamster::Hash do
  describe "#eql?" do
    describe "returns false when comparing with" do
      before do
        @hash = Hamster.hash("A" => "aye", "B" => "bee", "C" => "see")
      end

      it "a standard hash" do
        @hash.eql?("A" => "aye", "B" => "bee", "C" => "see").should == false
      end

      it "an arbitrary object" do
        @hash.eql?(Object.new).should == false
      end
    end
  end

  describe "#==" do
    describe "returns true when comparing with" do
      before do
        @hash = Hamster.hash("A" => "aye", "B" => "bee", "C" => "see")
      end

      it "a standard hash" do
        (@hash == {"A" => "aye", "B" => "bee", "C" => "see"}).should == true
      end
    end

    describe "returns false when comparing with" do
      it "an arbitrary object" do
        (@hash == Object.new).should == false
      end
    end
  end

  [:eql?, :==].each do |method|
    describe "##{method}" do
      [
        [{}, {}, true],
        [{ "A" => "aye" }, {}, false],
        [{}, { "A" => "aye" }, false],
        [{ "A" => "aye" }, { "A" => "aye" }, true],
        [{ "A" => "aye" }, { "B" => "bee" }, false],
        [{ "A" => "aye", "B" => "bee" }, { "A" => "aye" }, false],
        [{ "A" => "aye" }, { "A" => "aye", "B" => "bee" }, false],
        [{ "A" => "aye", "B" => "bee", "C" => "see" }, { "A" => "aye", "B" => "bee", "C" => "see" }, true],
        [{ "C" => "see", "A" => "aye", "B" => "bee" }, { "A" => "aye", "B" => "bee", "C" => "see" }, true],
      ].each do |a, b, expected|

        describe "returns #{expected.inspect}" do
          before do
            @a = Hamster.hash(a)
            @b = Hamster.hash(b)
          end

          it "for #{a.inspect} and #{b.inspect}" do
            @a.send(method, @b).should == expected
          end

          it "for #{b.inspect} and #{a.inspect}" do
            @b.send(method, @a).should == expected
          end
        end
      end
    end
  end
end