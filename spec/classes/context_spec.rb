require 'rspec'

module BehaviourNodeGraph
  describe Context do

    it { is_expected.to be_a_kind_of(Instructions) }

    describe '#values' do
      its(:values) { is_expected.to be_a_kind_of(Hash) }
    end

  end
end
