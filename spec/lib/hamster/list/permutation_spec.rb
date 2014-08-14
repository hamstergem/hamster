require "spec_helper"
require "hamster/list"

describe Hamster::List do
  [:permutation, :permutations].each do |method|
    describe "##{method}" do
      before do
        @list = Hamster.list(1,2,3,4,5)
      end

      context "with no block" do
        it "returns an Enumerator" do
          @list.send(method).class.should be(Enumerator)
        end
      end

      context "with no argument" do
        it "yields all permutations of the list" do
          perms = @list.send(method).to_a
          perms.size.should be(120)
          perms.sort.should == [1,2,3,4,5].permutation.to_a.sort
          perms.each { |item| item.should be_kind_of(Hamster::List) }
        end
      end

      context "with a length argument" do
        it "yields all N-size permutations of the list" do
          perms = @list.send(method, 3).to_a
          perms.size.should be(60)
          perms.sort.should == [1,2,3,4,5].permutation(3).to_a.sort
          perms.each { |item| item.should be_kind_of(Hamster::List) }
        end
      end

      context "with a length argument greater than length of list" do
        it "yields nothing" do
          @list.send(method, 6).to_a.should be_empty
        end
      end

      context "with a length argument of 0" do
        it "yields an empty list" do
          perms = @list.send(method, 0).to_a
          perms.size.should be(1)
          perms[0].should be_kind_of(Hamster::List)
          perms[0].should be_empty
        end
      end

      context "with a block" do
        it "returns the original list" do
          @list.send(method, 0) {}.should be(@list)
          @list.send(method, 1) {}.should be(@list)
          @list.send(method) {}.should be(@list)
        end
      end
    end
  end
end