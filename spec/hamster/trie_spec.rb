require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Hamster::Trie do
  
  before do
    @trie = Hamster::Trie.new(0)

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
  
  describe "#put" do
    
    describe "with keys that already exist" do

      it "returns the previous value" do
        @trie.put("A", "Aye").should == "a"
      end

      it "replaces the previous value" do
        @trie.put("A", "Aye")
        @trie.get("A").should == "Aye"
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

  end

end
