require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module Hamster

  describe Stack do

    describe "#empty?" do

      it "initially returns true" do
        Stack.new.should be_empty
      end

      it "returns false once items have been added" do
        Stack.new.push("A").should_not be_empty
      end

    end

  end

end
