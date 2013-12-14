require "spec_helper"

require "hamster/core_ext/enumerator"

describe Enumerator do

  describe "#to_list" do

    before do
      @enumerator = %w[A B C].to_enum
      @list = @enumerator.to_list
    end

    it "returns an equivalent list" do
      @list.should == Hamster.list("A", "B", "C")
    end

    it "is lazy" do
      @list.head.should == "A"
      @enumerator.next.should == "B"
    end

  end

end
