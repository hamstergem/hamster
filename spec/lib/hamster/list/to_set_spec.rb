require "hamster/list"
require "hamster/set"

RSpec.describe Hamster::List do
  describe "#to_set" do
    [
      [],
      ["A"],
      %w[A B C],
    ].each do |values|
      context "on #{values.inspect}" do
        it "returns a set with the same values" do
          expect(L[*values].to_set).to eql(S[*values])
        end
      end
    end
  end
end
