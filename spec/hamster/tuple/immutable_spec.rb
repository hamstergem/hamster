require File.expand_path('../../../spec_helper', __FILE__)

require 'hamster/immutable'
require 'hamster/tuple'

describe Hamster::Tuple do

  it "includes Immutable" do
    Hamster::Tuple.should include(Hamster::Immutable)
  end

end
