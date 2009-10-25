require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module Hamster

  describe Trie do

    describe "#get" do

      before do
        @trie = Trie.new
        @trie = @trie.put("A", "aye")
      end

      it "returns the value for an existing key" do
        @trie.get("A").should == "aye"
      end

      it "returns nil for a non-existing key" do
        @trie.get("B").should be_nil
      end

    end

  end

end
