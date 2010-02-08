require File.expand_path('../../../spec_helper', __FILE__)

require 'hamster/list'

describe Hamster::List do

  describe "#clear" do

    [
      [],
      ["A"],
      ["A", "B", "C"],
    ].each do |values|

      describe "on #{values}" do

        before do
          @original = Hamster.list(*values)
          @result = @original.clear
        end

        it "preserves the original" do
          @original.should == Hamster.list(*values)
        end

        it "returns an empty list" do
          @result.should be_empty
        end

      end

    end

  end

end
