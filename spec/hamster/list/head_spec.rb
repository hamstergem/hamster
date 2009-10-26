require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module Hamster

  describe List do

    describe "#head" do

      it "initially returns nil" do
        List.new.head.should be_nil
      end

      it "returns the first item in the list" do
        List.new.cons("A").head.should == "A"
      end

    end

  end

end
