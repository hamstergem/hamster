require "spec_helper"
require "hamster/vector"

describe Hamster::Vector do
  [:remove, :reject, :delete_if].each do |method|
    describe "##{method}" do
      [
        [[], []],
        [["A"], ["A"]],
        [%w[A B C], %w[A B C]],
        [%w[A b C], %w[A C]],
        [%w[a b c], []],
      ].each do |values, expected|

        describe "on #{values.inspect}" do
          before do
            @original = Hamster.vector(*values)
          end

          context "with a block" do
            before do
              @result = @original.send(method) { |item| item == item.downcase }
            end

            it "returns #{expected.inspect}" do
              @result.should eql(Hamster.vector(*expected))
            end
          end

          context "without a block" do
            before do
              @result = @original.send(method)
            end

            it "returns an Enumerator" do
              @result.class.should be(Enumerator)
              @result.each { |item| item == item.downcase }.should eql(Hamster.vector(*expected))
            end
          end
        end
      end
    end
  end
end