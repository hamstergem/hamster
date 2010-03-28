require File.expand_path('../../../spec_helper', __FILE__)

require 'hamster/immutable'
require 'hamster/stack'

describe Hamster::Stack do

  it "includes Immutable" do
    Hamster::Stack.should include(Hamster::Immutable)
  end

end
