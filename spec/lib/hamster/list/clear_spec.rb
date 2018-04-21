require "spec_helper"
require "hamster/list"

describe Hamster::List do
  describe "#clear" do
    [
      [],
      ["A"],
      %w[A B C],
    ].each do |values|
      describe "on #{values}" do
        let(:list) { L[*values] }

        it "preserves the original" do
          list.clear
          expect(list).to eql(L[*values])
        end

        it "returns an empty list" do
          expect(list.clear).to equal(L.empty)
        end
      end
    end
  end
end