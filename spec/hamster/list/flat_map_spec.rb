require 'spec_helper'

require 'hamster/list'

describe Hamster::List, '#flat_map' do
  subject { list.flat_map(&block) }
  let(:block) { ->(i) { [i, i+1, i*i]} }

  context 'with an empty list' do
    let(:list) { Hamster.list }
    it { should eq Hamster.list }
  end

  context 'with a block that returns an empty list' do
    let(:list) { Hamster.list(1,2,3) }
    let(:block) { ->(i){ [] } }
    it { should eq Hamster.list }
  end

  context 'with a list of one item' do
    let(:list) { Hamster.list(7) }
    it { should eq Hamster.list(7,8,49) }
  end

  context 'with a list of multiple items' do
    let(:list) { Hamster.list(1,2,3) }
    it { should eq Hamster.list(1,2,1, 2,3,4, 3,4,9) }
  end
end
