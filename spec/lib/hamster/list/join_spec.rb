require "hamster/list"

RSpec.describe Hamster::List do
  describe "#join" do
    context "on a really big list" do
      it "doesn't run out of stack" do
        expect { Hamster.interval(0, STACK_OVERFLOW_DEPTH).join }.not_to raise_error
      end
    end

    context "with a separator" do
      [
        [[], ""],
        [["A"], "A"],
        [%w[A B C], "A|B|C"]
      ].each do |values, expected|
        context "on #{values.inspect}" do
          let(:list) { L[*values] }

          it "preserves the original" do
            list.join("|")
            expect(list).to eql(L[*values])
          end

          it "returns #{expected.inspect}" do
            expect(list.join("|")).to eq(expected)
          end
        end
      end
    end

    context "without a separator" do
      [
        [[], ""],
        [["A"], "A"],
        [%w[A B C], "ABC"]
      ].each do |values, expected|
        context "on #{values.inspect}" do
          let(:list) { L[*values] }

          it "preserves the original" do
            list.join
            expect(list).to eql(L[*values])
          end

          it "returns #{expected.inspect}" do
            expect(list.join).to eq(expected)
          end
        end
      end
    end

    context "without a separator (with global default separator set)" do
      before { $, = '**' }
      let(:list) { L["A", "B", "C"] }
      after  { $, = nil }

      it "uses the default global separator" do
        expect(list.join).to eq("A**B**C")
      end
    end
  end
end
