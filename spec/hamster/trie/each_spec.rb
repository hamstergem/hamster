require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module Hamster

  describe Trie do

    describe "#each" do

      before do
        @trie = Trie.new
        @expected_pairs = { "A" => "aye", "B" => "bee", "C" => "sea" }
        @expected_pairs.each do |key, value|
          @trie = @trie.put(key, value)
        end
      end

      describe "with a block (internal iteration)" do

        it "returns self" do
          @trie.each {}.should == @trie
        end

        it "yields all key value pairs" do
          actual_pairs = {}
          @trie.each do |key, value|
            actual_pairs[key] = value
          end
          actual_pairs.should == @expected_pairs
        end

      end

      describe "with no block (external iteration)" do

        it "returns an enumerator over all key value pairs" do
          actual_pairs = {}
          enum = @trie.each
          loop do
            key, value = enum.next
            actual_pairs[key] = value
          end
          actual_pairs.should == @expected_pairs
        end

      end

    end

  end

end
