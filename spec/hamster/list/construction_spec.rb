require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe ".[]" do

    before do
      @list = Hamster::List["A", "B", "C"]
    end

    it "is equivalent to repeatedly using #cons" do
      @list.should eql(Hamster::List.new.cons("C").cons("B").cons("A"))
    end

  end

end
