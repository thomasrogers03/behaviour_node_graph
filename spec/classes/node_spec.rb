require 'rspec'

module BehaviourNodeGraph
  describe Node do

    let(:attribute) { :name }
    let(:attribute_value) { Faker::Lorem.word }
    let(:list_of_attributes) { [attribute] }
    let(:list_of_values) { [attribute_value] }
    let(:node_id) { SecureRandom.base64 }
    let(:node_klass) do
      Class.new(Struct.new(*list_of_attributes)) do
        include Node
      end
    end
    let(:node) { node_klass.new(node_id, *list_of_values) }

    describe '.new_node' do
      before { allow(SecureRandom).to receive(:base64).and_return(node_id) }

      subject { node_klass.new_node(*list_of_values) }

      its(:id) { is_expected.to eq(node_id) }
      it { is_expected.to eq(node) }
    end

    describe '.load_from_graph' do
      let(:graph) { {} }
      let(:node_graph) { {} }

      subject { Node.load_from_graph(graph, node_id, node_graph) }

      before { node.add_to_graph(graph) }

      it { is_expected.to eq(node) }

      it 'should save the node for later' do
        subject
        expect(node_graph[node_id]).to eq(node)
      end

      context 'when this node has already been added' do
        let(:node_value) { Faker::Lorem.sentence }
        let(:node_graph) { {node_id => node_value} }

        it { is_expected.to eq(node_value) }

        it 'should leave the cached value alone' do
          subject
          expect(node_graph[node_id]).to eq(node_value)
        end
      end
    end

    describe '#add_to_graph' do
      let(:graph) { {} }

      subject { graph[node_id] }

      before { node.add_to_graph(graph) }

      its(:node_type) { is_expected.to eq(node_klass) }
      its(:id) { is_expected.to eq(node_id) }
      its(:attributes) { is_expected.to eq(name: attribute_value) }

      context 'with multiple attributes' do
        let(:attribute_two) { :value }
        let(:attribute_value_two) { Faker::Lorem.sentence }
        let(:list_of_attributes) { [attribute, attribute_two] }
        let(:list_of_values) { [attribute_value, attribute_value_two] }

        its(:attributes) { is_expected.to eq(name: attribute_value, value: attribute_value_two) }
      end

      context 'when this node has already been added' do
        let(:node_value) { Faker::Lorem.sentence }
        let(:graph) { {node_id => node_value} }

        it { is_expected.to eq(node_value) }
      end
    end

    describe '#context' do
      let(:context) { SecureRandom.uuid }
      subject { node }
      before { subject.context = context }
      its(:context) { is_expected.to eq(context) }
    end

    describe 'node linking' do
      subject { node_klass.new(node_id) }

      it_behaves_like 'linking nodes together'
    end
  end
end
