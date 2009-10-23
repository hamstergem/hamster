require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module Hamster

  describe Trie do

    before do
      @expected_pairs = {}
      @trie = Trie.new

      ("A".."Z").each do |letter|
        @expected_pairs.store(letter, letter.downcase)
        @trie = @trie.put(letter, letter.downcase)
      end
    end

    def self.it_returns_values_associated_with_existing_keys
      it "returns values associated with existing keys" do
        ("A".."Z").each do |letter|
          @trie.get(letter).should == letter.downcase
        end
      end
    end

    it "is Enumerable" do
      Trie.is_a?(Enumerable)
    end

    describe "#empty?" do

      it "initially returns true" do
        Trie.new.should be_empty
      end

      it "returns false once items have been added" do
        @trie.should_not be_empty
      end

    end

    describe "#each" do

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

    describe "#get" do

      it_returns_values_associated_with_existing_keys

      it "returns nil for non-existing" do
        @trie.get("missing").should be_nil
      end

    end

    describe "#has_key?" do

      it "returns true for existing keys" do
        ("A".."Z").each do |letter|
          @trie.has_key?(letter).should be_true
        end
      end

      it "returns false for non-existing" do
        @trie.has_key?("missing").should be_false
      end

    end

    describe "#put" do

      describe "with key/value pairs that already exists" do

        before do
          @copy = @trie.put("A", "aye")
        end

        it "returns a modified copy" do
          @copy.should_not === @trie
        end

        describe "the original" do

          it_returns_values_associated_with_existing_keys

          it "has the original size" do
            @trie.size.should == 26
          end

        end

        describe "the modified copy" do

          it "has the new key/value pair" do
            @copy.get("A").should == "aye"
          end

          it "has the original size" do
            @trie.size.should == 26
          end

        end

      end

      describe "with key/value pairs that don't exist"

        before do
          @copy = @trie.put("missing", "in action")
        end

        it "returns a modified copy" do
          @copy.should_not === @trie
        end

        describe "the original" do

          it_returns_values_associated_with_existing_keys

          it "doesn't contain the new key/value pair" do
            @trie.has_key?("missing").should be_false
          end

          it "has the original size" do
            @trie.size.should == 26
          end

        end

        describe "the modified copy" do

          it_returns_values_associated_with_existing_keys

          it "has the new key/value pair" do
            @copy.get("missing").should == "in action"
          end

          it "size is increased by 1" do
            @copy.size.should == 27
          end

        end

    end

  end

end
