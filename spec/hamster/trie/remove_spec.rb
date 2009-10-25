require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

module Hamster

  describe Trie do

    describe "#remove" do

      describe "with an existing key" do

        before do
          @original = Trie.new.put("A", "aye").put("B", "bee")
          @copy = @original.remove("A")
        end

        it "returns a modified copy" do
          @copy.should_not === @original
        end

        describe "the original" do

          it "still has the original key/value pairs" do
            @original.get("A").should == "aye"
            @original.get("B").should == "bee"
          end

          it "still has the original size" do
            @original.size.should == 2
          end

        end

        describe "the modified copy" do

          it "has all but the removed original key/value pairs" do
            @copy.get("B").should == "bee"
          end

          it "doesn't have the removed key" do
            @copy.has_key?("A").should be_false
          end

          it "has a size one less than the original" do
            @copy.size.should == 1
          end

        end

      end

      describe "with non-existing keys" do

        before do
          @original = Trie.new.put("A", "aye")
          @copy = @original.remove("missing")
        end

        it "returns self" do
          @copy.should === @original
        end

        describe "the original" do

          it "still has the original key/value pairs" do
            @original.get("A").should == "aye"
          end

          it "still has the original size" do
            @original.size.should == 1
          end

        end

      end

      describe "with keys of the same hash value" do

        class Key
          def hash; 1; end
        end

        def number_of_tries
          ObjectSpace.garbage_collect
          ObjectSpace.each_object(Trie) {}
        end

        before do
          @a = Key.new
          @b = Key.new
          @original = Trie.new.put(@a, "aye").put(@b, "bee")
        end
        
        it "no longer provides access to the removed key" do
          copy = @original.remove(@b)
          copy.has_key?(@b).should be_false
        end

        it "provides access to the remaining keys" do
          copy = @original.remove(@a)
          copy.get(@b).should == "bee"
        end

        it "cleans up empty tries" do
          number_of_tries_before = number_of_tries
          @copy = @original.remove(@b)  # Use instance variable assignment to prevent predictive GC
          number_of_tries.should == number_of_tries_before + 1
        end

      end

    end

  end

end
