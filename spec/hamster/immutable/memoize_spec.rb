require "spec_helper"

require "hamster/immutable"

describe Hamster::Immutable do

  describe "#memoize" do

    class Fixture
      include Hamster::Immutable

      def initialize(&block)
        @block = block
      end

      def call
        @block.call
      end
      memoize :call

      def copy
        transform {}
      end

    end

    before do
      @count = 0
      @fixture = Fixture.new { @count += 1 }
      @fixture.call
    end

    it "should still freezes be immutable" do
      @fixture.should be_immutable
    end

    describe "when called multiple times" do

      before do
        @fixture.call
      end

      it "a memoized method will only be evaluated once" do
        @count.should == 1
      end

    end

    describe "when making a copy" do

      before do
        @copy = @fixture.copy
        @copy.call
      end

      it "should clear all memory" do
        @count.should == 2
      end

    end

  end

end
