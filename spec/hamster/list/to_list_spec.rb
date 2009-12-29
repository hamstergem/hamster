require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

require 'hamster/list'

describe Hamster::List do

  describe "#to_list" do

    [
      [],
      ["A"],
      ["A", "B", "C"],
    ].each do |values|

      describe "on #{values.inspect}" do

        before do
          @list = Hamster.list(*values)
        end

        it "returns self" do
          @list.to_list.should equal(@list)
        end

      end

    end

  end

end
