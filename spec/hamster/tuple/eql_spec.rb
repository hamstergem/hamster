require "spec_helper"

require "hamster/tuple"

describe Hamster::Tuple do

  before do
    @tuple = Hamster::Tuple.new("A", "B", "C")
  end

  describe "#==" do

    describe "returns true when comparing with" do

      it "an array with the same values" do
        @tuple.should == ["A", "B", "C"]
      end

      it "a List with the same values" do
        @tuple.should == Hamster.list("A", "B", "C")
      end

      it "a Tuple with the same values" do
        @tuple.should == Hamster::Tuple.new("A", "B", "C")
      end

    end

    describe "returns false when comparing with" do

      it "an array with different values" do
        @tuple.should_not == ["A", "B"]
      end

      it "a Tuple with different values" do
        @tuple.should_not == Hamster::Tuple.new("A")
      end

      it "an arbitrary object" do
        @tuple.should_not == Object.new
      end

    end

  end

  describe "#eql?" do

    describe "returns false when comparing with" do

      it "an array with the same values" do
        @tuple.should_not eql(%w[A B C])
      end

      it "an arbitrary object" do
        @tuple.should_not eql(Object.new)
      end

    end

    [
      [[], [], true],
      [[], [nil], false],
      [["A"], [], false],
      [["A"], ["A"], true],
      [["A"], ["B"], false],
      [%w[A B], ["A"], false],
      [%w[A B C], %w[A B C], true],
      [%w[C A B], %w[A B C], false],
    ].each do |a, b, expected|

      describe "returns #{expected.inspect}" do

        before do
          @a = Hamster::Tuple.new(*a)
          @b = Hamster::Tuple.new(*b)
        end

        it "for #{a.inspect} and #{b.inspect}" do
          @a.eql?(@b).should == expected
        end

        it "for #{b.inspect} and #{a.inspect}" do
          @b.eql?(@a).should == expected
        end

      end

    end

  end

end
