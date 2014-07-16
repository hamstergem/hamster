require 'spec_helper'
require 'hamster/tuple'

describe Hamster do
  describe '.tuple' do
    context 'with no arguments' do
      let(:tuple) { Hamster.tuple }

      it 'always returns the same instance' do
        expect(tuple).to eq(Hamster.tuple)
      end

      it 'returns an empty queue' do
        expect(tuple).to be_empty
      end
    end

    context 'with a number of items' do
      let(:tuple) { Hamster.tuple('A', 'B', 'C') }

      it 'always returns the same instance' do
        expect(tuple).to eq(Hamster.tuple('A', 'B', 'C'))
      end

      it 'same as constructing a new Tuple directly' do
        expect(tuple).to eq(Hamster::Tuple.new('A', 'B', 'C'))
      end
    end
  end
end
