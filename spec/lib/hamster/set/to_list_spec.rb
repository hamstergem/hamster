require "hamster/set"
require "hamster/list"

RSpec.describe Hamster::Set do
  describe "#to_list" do
    [
      [],
      ["A"],
      %w[A B C],
    ].each do |values|
      context "on #{values.inspect}" do
        let(:set) { S[*values] }
        let(:list) { set.to_list }

        it "returns a list" do
          expect(list.is_a?(Hamster::List)).to eq(true)
        end

        it "doesn't change the original Set" do
          list
          expect(set).to eql(S.new(values))
        end

        describe "the returned list" do
          it "has the correct length" do
            expect(list.size).to eq(values.size)
          end

          it "contains all values" do
            expect(list.to_a.sort).to eq(values.sort)
          end
        end
      end
    end
  end
end
