require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::List do

  describe "#cadr" do

    [
      [[], :car, nil],
      [["A"], :car, "A"],
      [["A", "B", "C"], :car, "A"],
      [["A", "B", "C"], :cadr, "B"],
      [["A", "B", "C"], :caddr, "C"],
      [["A", "B", "C"], :cadddr, nil],
      [["A", "B", "C"], :caddddr, nil],
      [[], :cdr, Hamster.list],
      [["A"], :cdr, Hamster.list],
      [["A", "B", "C"], :cdr, Hamster.list("B", "C")],
      [["A", "B", "C"], :cddr, Hamster.list("C")],
      [["A", "B", "C"], :cdddr, Hamster.list],
      [["A", "B", "C"], :cddddr, Hamster.list],
    ].each do |values, method, result|

      describe "on #{values.inspect}" do

        list = Hamster.list(*values)

        it "returns #{result}" do
          list.send(method).should == result
        end

      end

    end

  end

end
