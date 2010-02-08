require File.expand_path('../../../spec_helper', __FILE__)

require 'hamster/hash'

describe Hamster::Hash do

  before do
    @hash = Hamster.hash("A" => "aye", "B" => "bee", "C" => "see")
  end

  [:dup, :clone].each do |method|

    describe "##{method}" do

      it "returns self" do
        @hash.send(method).should equal(@hash)
      end

    end

  end

end
