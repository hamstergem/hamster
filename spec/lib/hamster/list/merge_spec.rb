require "spec_helper"

require "hamster/list"

describe Hamster::List do

  context "without a comparator" do

    context "on an empty list" do

      subject { Hamster.list }

      it "returns an empty list" do
        subject.merge.should be_empty
      end

    end

    context "on a single list" do

      let(:list) { Hamster.list(1, 2, 3) }

      subject { Hamster.list(list) }

      it "returns the list" do
        subject.merge.should == list
      end

    end

    context "with multiple lists" do

      subject { Hamster.list(Hamster.list(3, 6, 7, 8), Hamster.list(1, 2, 4, 5, 9)) }

      it "merges the lists based on natural sort order" do
        subject.merge.should == Hamster.list(1, 2, 3, 4, 5, 6, 7, 8, 9)
      end

    end

  end

  context "with a comparator" do

    context "on an empty list" do

      subject { Hamster.list }

      it "returns an empty list" do
        subject.merge { |a, b| fail("should never be called") }.should be_empty
      end

    end

    context "on a single list" do

      let(:list) { Hamster.list(1, 2, 3) }

      subject { Hamster.list(list) }

      it "returns the list" do
        subject.merge { |a, b| fail("should never be called") }.should == list
      end

    end

    context "with multiple lists" do

      subject { Hamster.list(Hamster.list(8, 7, 6, 3), Hamster.list(9, 5, 4, 2, 1)) }

      it "merges the lists based on the specified comparator" do
        subject.merge { |a, b| b <=> a }.should == Hamster.list(9, 8, 7, 6, 5, 4, 3, 2, 1)
      end

    end

  end

end
