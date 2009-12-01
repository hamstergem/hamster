require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  (1..5).each do |i|

    method_name = "ca#{'d' * i}r"
    values = (1..6).to_a
    expected_result = i + 1

    describe "##{method_name}" do

      it "when empty is nil" do
        Hamster.list.send(method_name).should be_nil
      end

      it "with #{values} is #{i + 1}" do
        list = values.reverse.inject(Hamster.list) { |list, i| list.cons(i) }
        list.send(method_name).should == expected_result
      end

    end

  end

end
