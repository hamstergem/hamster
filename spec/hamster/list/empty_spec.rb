require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module Hamster

  describe List do

    describe "#empty?" do

      it "initially returns true" do
        List.new.should be_empty
      end

      it "returns false once items have been added" do
        list = List.new.cons("A")
        list.should_not be_empty
      end

    end

  end

end
