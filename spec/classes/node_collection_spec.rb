require 'rspec'

module BehaviourNodeGraph
  describe NodeCollection do

    let(:node_id) { SecureRandom.base64 }
    let(:node_klass) { BehaviourNodeGraph.define_simple_node {} }
    let(:list_of_nodes) { [] }
    let(:node_collection) { NodeCollection.new(node_id, list_of_nodes) }

    subject { node_collection }

    describe '.load_from_graph' do
      let(:node) { node_klass.new(SecureRandom.base64) }
      let(:list_of_nodes) { [node] }
      let(:graph) { {} }
      let(:node_graph) { {} }

      subject { Node.load_from_graph(graph, node_id, node_graph) }

      before { node_collection.add_to_graph(graph) }

      its(:id) { is_expected.to eq(node_id) }
      its(:children) { is_expected.to eq(list_of_nodes) }

      it 'should save the node for later' do
        subject
        expect(node_graph[node_id]).to eq(subject)
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

      context 'with a custom context type' do
        let(:context_type) { Class.new(Context) }
        let(:node_collection) { NodeCollection.new(node_id, list_of_nodes, context_type) }

        it 'should assign the context type to the new node' do
          expect(subject.context_type).to eq(context_type)
        end
      end
    end

    its(:id) { is_expected.to eq(node_id) }

    describe '#context_type' do
      its(:context_type) { is_expected.to eq(Context) }

      context 'with a custom context type' do
        let(:context_type) { Class.new(Context) }
        let(:node_collection) { NodeCollection.new(node_id, list_of_nodes, context_type) }

        its(:context_type) { is_expected.to eq(context_type) }
      end
    end

    describe '#children' do
      its(:children) { is_expected.to be_empty }

      context 'with a child node' do
        let(:node) { node_klass.new(SecureRandom.base64) }
        let(:list_of_nodes) { [node] }

        its(:children) { is_expected.to eq(list_of_nodes) }

        context 'with multiple children' do
          let(:node_two) { node_klass.new(SecureRandom.base64) }
          let(:list_of_nodes) { [node, node_two] }

          its(:children) { is_expected.to eq(list_of_nodes) }
        end
      end
    end

    describe '#add_to_graph' do
      let(:graph) { {} }
      let(:child_graph) { {} }
      let(:node) { node_klass.new(SecureRandom.base64) }
      let(:list_of_nodes) { [node] }

      subject { graph[node_id] }

      before do
        node.add_to_graph(child_graph)
        node_collection.add_to_graph(graph)
      end

      its(:node_type) { is_expected.to eq(NodeCollection) }
      its(:id) { is_expected.to eq(node_id) }
      its(:children) { is_expected.to eq([node.id]) }
      its(:to_h) { is_expected.not_to include(:context_type) }
      it { expect(graph).to include(child_graph) }

      context 'when this node has already been added' do
        let(:node_value) { Faker::Lorem.sentence }
        let(:graph) { {node_id => node_value} }

        it { is_expected.to eq(node_value) }
      end

      context 'with a custom context type' do
        let(:context_type) { Class.new(Context) }
        let(:node_collection) { NodeCollection.new(node_id, list_of_nodes, context_type) }

        its(:context_type) { is_expected.to eq(context_type) }
      end
    end

    describe '#context' do
      let(:context) { SecureRandom.uuid }
      subject { node_collection }
      before { subject.context = context }
      its(:context) { is_expected.to eq(context) }
    end

    describe '#act' do
      let(:context) {}
      let(:node) { node_klass.new(SecureRandom.base64) }
      let(:list_of_nodes) { [node] }

      subject { node_collection }

      before { subject.context = context }

      it 'creates a new context' do
        subject.act
        expect(subject.context).to be_a_kind_of(Context)
      end

      it 'sets the child node context to the new context' do
        subject.act
        expect(node.context).to eq(subject.context)
      end

      it 'calls #act on the child node' do
        expect(node).to receive(:act)
        subject.act
      end

      context 'with a previously existing context' do
        let(:context) { Context.new(hello: :world) }

        it 'creates uses that context' do
          subject.act
          expect(subject.context).to eq(context)
        end
      end

      context 'with multiple children' do
        let(:node_two) { node_klass.new(SecureRandom.base64) }
        let(:list_of_nodes) { [node, node_two] }

        it 'calls #act on the first child' do
          expect(node).to receive(:act)
          subject.act
        end

        it 'calls #act on the second child' do
          expect(node_two).to receive(:act)
          subject.act
        end
      end
    end

  end
end
