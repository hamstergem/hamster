require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module Hamster

  describe Trie do

    it "is Enumerable" do
      Trie.ancestors.should include(Enumerable)
    end

  end

end
