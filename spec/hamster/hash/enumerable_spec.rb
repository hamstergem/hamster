require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Hamster::Hash do

  it "is Enumerable" do
    Hamster::Hash.ancestors.should include(Enumerable)
  end

end
