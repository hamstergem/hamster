require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

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
