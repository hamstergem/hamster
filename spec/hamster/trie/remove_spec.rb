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
          @number_of_tries_before = ObjectSpace.each_object(Trie) {}
        end

        before do
          a = Key.new
          @b = Key.new
          @trie = Trie.new.put(a, "A").put(@b, "B")
          @number_of_tries_before = number_of_tries
          @trie = @trie.remove(a)
        end

        it "continues to provide access to keys with the same hash value" do
          @trie.get(@b).should == "B"
        end

        it "cleans up empty tries" do
          number_of_tries.should == @number_of_tries_before - 1
        end

      end

    end

  end

end
