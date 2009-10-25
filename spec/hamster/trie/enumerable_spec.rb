require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module Hamster

  describe Trie do

    it "is Enumerable" do
      Trie.is_a?(Enumerable)
    end

  end

end
