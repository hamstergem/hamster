require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  describe "#reverse_each" do
    [2, 31, 32, 33, 1000, 1024, 1025, 2000].each do |size|
      context "on a #{size}-item vector" do
        let(:vector) { V[1..size] }

        context "with a block (internal iteration)" do
          it "returns self" do
            expect(vector.reverse_each {}).to be(vector)
          end

          it "yields all items in the opposite order as #each" do
            result = []
            vector.reverse_each { |item| result << item }
            expect(result).to eql(vector.to_a.reverse)
          end
        end

        context "with no block" do
          it "returns an Enumerator" do
            result = vector.reverse_each
            expect(result.class).to be(Enumerator)
            expect(result.to_a).to eql(vector.to_a.reverse)
          end
        end
      end
    end
  end
end