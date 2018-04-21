require "hamster/list"

RSpec.describe Hamster::List do
  describe "#to_list" do
    [
      [],
      ["A"],
      %w[A B C],
    ].each do |values|
      context "on #{values.inspect}" do
        let(:list) { L[*values] }

        it "returns self" do
          expect(list.to_list).to equal(list)
        end
      end
    end
  end
end
