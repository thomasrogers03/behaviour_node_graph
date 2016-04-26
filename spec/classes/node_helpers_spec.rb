require 'rspec'

module BehaviourNodeGraph

  describe '.define_simple_node' do
    let(:attributes) { [] }
    let(:act_result) { Faker::Lorem.sentence }
    let(:act_block) do
      result = act_result
      ->() { result }
    end
    let(:node_klass) { BehaviourNodeGraph.define_simple_node(*attributes, &act_block) }

    subject { node_klass.new_node }

    it { is_expected.to be_a_kind_of(Node) }
    its(:to_h) { is_expected.to eq({}) }
    its(:act) { is_expected.to eq(act_result) }

    context 'with attributes' do
      let(:attributes) { Faker::Lorem.words.map(&:to_sym) }

      it { is_expected.to be_a_kind_of(Node) }
      its(:members) { is_expected.to eq(attributes) }
      its(:to_h) { is_expected.to include(*attributes) }
      its(:act) { is_expected.to eq(act_result) }
    end
  end

end
