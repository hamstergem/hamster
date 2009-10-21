require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Hamster::Trie do
  
  before do
    @trie = Hamster::Trie.new(0)

    ("A".."Z").each do |letter|
      @trie.put(letter, letter.downcase)
    end    
  end

  describe "#get" do

    it "returns values associated with keys that exist" do
      ("A".."Z").each do |letter|
        @trie.get(letter).should == letter.downcase
      end
    end
    
    it "returns nil for keys that don't exist" do
      @trie.get("missing").should be_nil
    end
    
  end

end
