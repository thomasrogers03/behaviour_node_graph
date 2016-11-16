require 'rspec'

module BehaviourNodeGraph
  describe ScriptNodeBuilder do

    let(:builder_klass) do
      Class.new { extend ScriptNodeBuilder }
    end


    describe '#node_cache' do
      let(:five_minutes) { 5 * 60 }

      subject { builder_klass.node_cache }

      it { is_expected.to be_a_kind_of(LruRedux::TTL::ThreadSafeCache) }
      its(:max_size) { is_expected.to eq(100) }
      its(:ttl) { is_expected.to eq(five_minutes) }
    end

  end
end
