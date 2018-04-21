require "hamster/immutable"

describe Hamster::Immutable do
  class Fixture
    include Hamster::Immutable
  end

  [:dup, :clone].each do |method|
    describe "##{method}" do
      before do
        @original = Fixture.new
        @result = @original.send(method)
      end

      it "returns self" do
        expect(@result).to equal(@original)
      end
    end
  end
end
