require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

module Hamster

  describe Trie do
  
    before do
      @trie = Trie.new

      ("A".."Z").each do |letter|
        @trie.put(letter, letter.downcase)
      end    
    end

    describe "#get" do

      it "returns values associated with existing keys" do
        ("A".."Z").each do |letter|
          @trie.get(letter).should == letter.downcase
        end
      end
    
      it "returns nil for non-existing" do
        @trie.get("missing").should be_nil
      end
    
    end
  
    describe "#has_key?" do

      it "returns true with existing keys" do
        ("A".."Z").each do |letter|
          @trie.has_key?(letter).should be_true
        end
      end
    
      it "returns false for non-existing" do
          @trie.has_key?("missing").should be_false
      end

    end
  
    describe "#put" do
    
      describe "with keys that already exist" do

        it "returns the previous value" do
          @trie.put("A", "Aye").should == "a"
        end

        it "replaces the previous value" do
          @trie.put("A", "Aye")
          @trie.get("A").should == "Aye"
        end
      
        it "leaves size unchanged" do
          @trie.size.should == 26
        end
      
      end
    
      describe "with keys that don't exist"
    
        it "returns nil" do
          @trie.put("missing", "in action").should be_nil
        end
    
        it "sets the value" do
          @trie.put("missing", "in action")
          @trie.get("missing").should == "in action"
        end
      
        it "increases size by 1" do
          @trie.put("missing", "in action")
          @trie.size.should == 27
        end

    end

  end

end
