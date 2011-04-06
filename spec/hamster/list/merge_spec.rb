require 'spec_helper'

require 'hamster/list'

describe Hamster::List do

  context "on an empty list" do

    subject { Hamster.list }

    its(:merge) { should be_empty }

  end

  context "on a a single list" do

    let(:list) { Hamster.list(1,2,3) }

    subject { Hamster.list(list) }

    its(:merge) { should == list }

  end

  context "with multiple lists" do

    subject { Hamster.list(Hamster.list("C", "F", "G", "H"), Hamster.list("A", "B", "D", "E", "I"))}

    its(:merge) { should == ["A", "B", "C", "D", "E", "F", "G", "H", "I"] }

  end

end
