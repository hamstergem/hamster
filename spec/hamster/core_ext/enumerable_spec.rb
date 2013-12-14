require "spec_helper"

require "hamster/core_ext/enumerable"

describe Enumerable do

  class TestEnumerable

    include Enumerable

    def initialize(*values)
      @values = values
    end

    def each(&block)
      @values.each(&block)
    end

  end

  describe "#to_list" do

    before do
      enumerable = TestEnumerable.new("A", "B", "C")
      @list = enumerable.to_list
    end

    it "returns an equivalent list" do
      @list.should == Hamster.list("A", "B", "C")
    end

  end

end
