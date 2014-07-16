require "spec_helper"
require "hamster/set"

describe Hamster::Set do
  [:group_by, :group].each do |method|
    describe "##{method}" do
      describe "with a block" do
        [
          [[], []],
          [[1], [true => Hamster.set(1)]],
          [[1, 2, 3, 4], [true => Hamster.set(3, 1), false => Hamster.set(4, 2)]],
        ].each do |values, expected|

          describe "on #{values.inspect}" do
            before do
              original = Hamster.set(*values)
              @result = original.send(method, &:odd?)
            end

            it "returns #{expected.inspect}" do
              @result.should == Hamster.hash(*expected)
            end
          end
        end
      end

      describe "without a block" do
        [
          [[], []],
          [[1], [1 => Hamster.set(1)]],
          [[1, 2, 3, 4], [1 => Hamster.set(1), 2 => Hamster.set(2), 3 => Hamster.set(3), 4 => Hamster.set(4)]],
        ].each do |values, expected|

          describe "on #{values.inspect}" do
            before do
              original = Hamster.set(*values)
              @result = original.group_by
            end

            it "returns #{expected.inspect}" do
              @result.should == Hamster.hash(*expected)
            end
          end
        end
      end

      context "from a subclass" do
        it "returns an Hash whose values are instances of the subclass" do
          @subclass = Class.new(Hamster::Set)
          @instance = @subclass.new(1, 'string', :symbol)
          @instance.group_by { |x| x.class }.values.each { |v| v.class.should be(@subclass) }
        end
      end
    end
  end
end