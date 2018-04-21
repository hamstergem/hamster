require "hamster/list"

RSpec.describe Hamster::List do
  describe "#each" do
    context "on a really big list" do
      it "doesn't run out of stack" do
        expect { Hamster.interval(0, STACK_OVERFLOW_DEPTH).each { |item| } }.not_to raise_error
      end
    end

    [
      [],
      ["A"],
      %w[A B C],
    ].each do |values|
      context "on #{values.inspect}" do
        let(:list) { L[*values] }

        context "with a block" do
          it "iterates over the items in order" do
            yielded = []
            list.each { |item| yielded << item }
            expect(yielded).to eq(values)
          end

          it "returns nil" do
            expect(list.each { |item| item }).to be_nil
          end
        end

        context "without a block" do
          it "returns an Enumerator" do
            expect(list.each.class).to be(Enumerator)
            expect(Hamster::List[*list.each]).to eql(list)
          end
        end
      end
    end
  end
end
