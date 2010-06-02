require 'spec_helper'

require 'hamster/immutable'
require 'hamster/hash'

describe "Hamster.Hash" do

  it "includes Immutable" do
    Hamster::Private::Hash.should include(Hamster::Immutable)
  end

end
