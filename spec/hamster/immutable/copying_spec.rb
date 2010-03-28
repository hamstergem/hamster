require File.expand_path('../../../spec_helper', __FILE__)

require 'hamster/immutable'

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
        @result.should equal(@original)
      end

    end

  end

end
