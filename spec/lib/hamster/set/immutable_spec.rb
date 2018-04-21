require "spec_helper"
require "hamster/immutable"
require "hamster/set"

describe Hamster::Set do
  it "includes Immutable" do
    expect(Hamster::Set).to include(Hamster::Immutable)
  end
end