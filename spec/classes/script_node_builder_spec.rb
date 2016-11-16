require 'rspec'

module BehaviourNodeGraph
  describe ScriptNodeBuilder do

    let(:builder_klass) do
      Class.new do
        extend ScriptNodeBuilder

        def self.build(code)
          Digest::MD5.hexdigest(code)
        end
      end
    end

    subject { builder_klass }

    describe '.node_cache' do
      let(:five_minutes) { 5 * 60 }

      subject { builder_klass.node_cache }

      it { is_expected.to be_a_kind_of(LruRedux::TTL::ThreadSafeCache) }
      its(:max_size) { is_expected.to eq(100) }
      its(:ttl) { is_expected.to eq(five_minutes) }
    end

    describe '.fetch' do
      let(:code) { Faker::Lorem.sentence }
      let(:script_sha) { Digest::SHA1.base64digest(code) }
      let(:script_md5) { Digest::MD5.hexdigest(code) }

      it 'returns the node generated from build' do
        expect(builder_klass.fetch(code)).to eq(script_md5)
      end

      it 'caches the node' do
        builder_klass.fetch(code)
        expect(builder_klass).not_to receive(:build)
        builder_klass.fetch(code)
      end

      it 'uses the sha-1 of the code as the key' do
        builder_klass.fetch(code)
        expect(builder_klass.node_cache[script_sha]).to eq(script_md5)
      end
    end

  end
end
