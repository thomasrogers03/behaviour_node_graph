require 'rspec'

module BehaviourNodeGraph
  describe SetConstant do

    let(:node_id) { SecureRandom.base64 }
    let(:target) { SecureRandom.base64 }
    let(:value) { Faker::Lorem.sentence }
    let(:node) { SetConstant.new(node_id, target, value) }

    subject { node }

    it { is_expected.to be_a_kind_of(Node) }

    describe '#act' do
      let(:context) { Context.new }

      subject { context }

      before do
        node.context = context
        node.act
      end

      its(:values) { is_expected.to include(target => value) }
    end

    it_behaves_like 'linking nodes together'

  end
end
