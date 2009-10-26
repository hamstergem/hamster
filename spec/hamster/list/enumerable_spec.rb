require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module Hamster

  describe List do

    it "is Enumerable" do
      List.ancestors.should include(Enumerable)
    end

  end

end
