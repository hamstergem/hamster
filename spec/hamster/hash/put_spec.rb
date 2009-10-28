require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Hash do

  describe "#put" do

    describe "with a key/value pair that already exists" do

      before do
        @original = Hamster::Hash.new.put("A", "aye").put("B", "bee")
        @copy = @original.put("A", "yes")
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

        it "has the new key/value pairs" do
          @copy.get("A").should == "yes"
          @copy.get("B").should == "bee"
        end

        it "has the original size" do
          @copy.size == 2
        end

      end

    end

    describe "with a key/value pair that doesn't exist" do

      before do
        @original = Hamster::Hash.new.put("A", "aye")
        @copy = @original.put("B", "bee")
      end

      it "returns a modified copy" do
        @copy.should_not === @original
      end

      describe "the original" do

        it "still has the original key/value pairs" do
          @original.get("A").should == "aye"
        end

        it "doesn't contain the new key/value pair" do
          @original.has_key?("B").should be_false
        end

        it "still has the original size" do
          @original.size.should == 1
        end

      end

      describe "the modified copy" do

        it "has the original key/value pairs" do
          @copy.get("A").should == "aye"
        end

        it "has the new key/value pair" do
          @copy.get("B").should == "bee"
        end

        it "size is increased by one" do
          @copy.size.should == 2
        end

      end

    end

  end

end
