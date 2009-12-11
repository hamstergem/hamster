require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Set do

  describe "#to_a" do

    [
      [],
      ["A"],
      ["A", "B", "C"],
    ].each do |values|

      describe "on #{values.inspect}" do

        before do
          @set = Hamster.set(*values)
        end

        it "returns #{values.inspect}" do
          @set.to_a.sort.should == values.sort
        end

      end

    end

  end

end
