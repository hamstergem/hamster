require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module Hamster

  describe Trie do

    describe "#has_key?" do

      before do
        @trie = Trie.new.put("A", "aye")
      end

      it "returns true for an existing key" do
        @trie.has_key?("A").should be_true
      end

      it "returns false for a non-existing key" do
        @trie.has_key?("B").should be_false
      end

    end

  end

end
