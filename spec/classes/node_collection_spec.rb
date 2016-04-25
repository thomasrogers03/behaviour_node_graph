require 'rspec'

module BehaviourNodeGraph
  describe NodeCollection do

    let(:node_id) { SecureRandom.base64 }
    let(:node_klass) do
      Class.new do
        include Node

        def to_h
          {}
        end

        def act

        end

        def ==(rhs)
          rhs.is_a?(self.class) && id == rhs.id
        end
      end
    end
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
    end

    its(:id) { is_expected.to eq(node_id) }

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
      it { expect(graph).to include(child_graph) }

      context 'when this node has already been added' do
        let(:node_value) { Faker::Lorem.sentence }
        let(:graph) { {node_id => node_value} }

        it { is_expected.to eq(node_value) }
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
        expect(subject.context).to be_a_kind_of(Instructions)
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
        let(:context) { Instructions.new(hello: :world) }

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
