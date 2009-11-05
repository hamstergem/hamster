require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#cadr" do

    it "initially returns nil" do
      Hamster::List.new.cadr.should be_nil
    end

    it "[1, 2, 3] is 2" do
      list = Hamster::List.new.cons(3).cons(2).cons(1)
      list.cadr.should == 2
    end

  end

  describe "#caddr" do

    it "initially returns nil" do
      Hamster::List.new.caddr.should be_nil
    end

    it "[1, 2, 3] is 2" do
      list = Hamster::List.new.cons(3).cons(2).cons(1)
      list.caddr.should == 3
    end

  end

end
