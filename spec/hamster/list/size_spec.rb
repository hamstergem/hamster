require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  [:size, :length].each do |method|

    describe "##{method}" do

      it "returns 0 for the empty list" do
        Hamster.list.send(method).should == 0
      end

      [
        [[], 0],
        [["A"], 1],
        [["A", "B", "C"], 3],
      ].each do |values, result|

        it "returns #{result} for #{values.inspect}" do
          Hamster.list(*values).send(method).should == result
        end

      end

    end

  end

end
