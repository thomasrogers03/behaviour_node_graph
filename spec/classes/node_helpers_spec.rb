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
    let(:node) { node_klass.new_node }
    let(:node_id) { node.id }

    subject { node }

    shared_examples_for 'node metadata' do |name|
      subject { node_klass }
      its(name) { is_expected.to eq([]) }

      context 'when set' do
        let(:attribute_value) { Faker::Lorem.words }
        before { node_klass.public_send(:"#{name}=", attribute_value) }

        its(name) { is_expected.to eq(attribute_value) }

        context 'with attributes' do
          let(:attributes) { Faker::Lorem.words.map(&:to_sym) }
          its(name) { is_expected.to eq(attribute_value) }
        end
      end
    end

    it_behaves_like 'node metadata', :inputs
    it_behaves_like 'node metadata', :outputs
    it_behaves_like 'node metadata', :output_nodes
    it_behaves_like 'node metadata', :properties

    it { is_expected.to be_a_kind_of(Node) }
    its(:to_h) { is_expected.to eq({}) }
    its(:act) { is_expected.to eq(act_result) }

    describe '#act' do
      let(:node_context) { Context.new } # note: this must not be called context, otherwise the test will pass!
      let(:node_klass) do
        result = act_result
        BehaviourNodeGraph.define_simple_node(*attributes) do
          context.values[:result] = result
        end
      end

      before { subject.context = node_context }

      it 'calls the block within context of the Node' do
        subject.act
        expect(node_context.values[:result]).to eq(act_result)
      end

      context 'with attributes' do
        let(:attributes) { Faker::Lorem.words.map(&:to_sym) }

        it 'calls the block within context of the Node' do
          subject.act
          expect(node_context.values[:result]).to eq(act_result)
        end
      end
    end

    context 'with attributes' do
      let(:attributes) { Faker::Lorem.words.map(&:to_sym) }

      it { is_expected.to be_a_kind_of(Node) }
      its(:members) { is_expected.to eq(attributes) }
      its(:to_h) { is_expected.to include(*attributes) }
      its(:act) { is_expected.to eq(act_result) }

      it_behaves_like 'linking nodes together'
    end

    it_behaves_like 'linking nodes together'

    describe '#==' do
      let(:lhs) { node_klass.new_node }
      let(:rhs) { node_klass.new(lhs.id) }

      subject { lhs == rhs }

      it { is_expected.to eq(true) }

      context 'with 2 different ids' do
        let(:rhs) { node_klass.new_node }
        it { is_expected.to eq(false) }
      end

      context 'with different types' do
        let(:node_klass_two) { BehaviourNodeGraph.define_simple_node(*attributes, &act_block) }
        let(:rhs) { node_klass_two.new(lhs.id) }
        it { is_expected.to eq(false) }
      end
    end
  end

end
