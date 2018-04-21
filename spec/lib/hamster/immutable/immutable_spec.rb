require "hamster/immutable"

describe Hamster::Immutable do
  describe "#immutable?" do
    describe "object constructed after its class becomes Immutable" do
      class Fixture
        include Hamster::Immutable
      end

      before do
        @fixture = Fixture.new
      end

      it "returns true" do
        expect(@fixture).to be_immutable
      end
    end

    describe "object constructed before its class becomes Immutable" do
      before do
        @fixture = Class.new.new
        @fixture.class.instance_eval do
          include Hamster::Immutable
        end
      end

      describe "that are not frozen" do
        it "returns false" do
          expect(@fixture).not_to be_immutable
        end
      end

      describe "that are frozen" do
        before do
          @fixture.freeze
        end

        it "returns true" do
          expect(@fixture).to be_immutable
        end
      end
    end
  end
end
