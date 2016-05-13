module BehaviourNodeGraph
  shared_examples_for 'linking nodes together' do
    let(:next_node_klass) { BehaviourNodeGraph.define_simple_node {} }
    let(:next_node) { double(:node, :context= => nil, act: nil) }

    before { subject.next_node = next_node }

    describe '#next_node' do
      its(:next_node) { is_expected.to eq(next_node) }
    end

    describe '#add_to_graph' do
      let(:graph) { {} }
      let(:child_graph) { {} }
      let(:next_node) { next_node_klass.new_node }

      before do
        next_node.add_to_graph(child_graph) if next_node
        subject.add_to_graph(graph)
      end

      it 'saves the next node' do
        expect(graph).to include(child_graph)
      end

      it 'references the next node' do
        expect(graph[node_id].next_node).to eq(next_node.id)
      end

      context 'with no node set' do
        let(:next_node) { nil }

        it 'saves the next node' do
          expect(graph).not_to include(child_graph)
        end

        it 'references the next node' do
          expect(graph[node_id].to_h).not_to include(:next_node)
        end
      end
    end

    describe '.load_from_graph' do
      let(:graph) { {} }
      let(:node_graph) { {} }
      let(:next_node) { next_node_klass.new_node }

      before { subject.add_to_graph(graph) }

      it 'should load the next node from the graph' do
        node = Node.load_from_graph(graph, node_id, node_graph)
        expect(node.next_node).to eq(next_node)
      end

    end

    describe '#act' do
      let(:context) { double(:context) }

      before { subject.context = context }

      it 'sets the context for the next node' do
        expect(next_node).to receive(:context=).with(context)
        subject.act
      end

      it 'calls #act on the next node' do
        expect(next_node).to receive(:act)
        subject.act
      end

      context 'with no node' do
        let(:next_node) { nil }

        it 'does nothing with it' do
          expect { subject.act }.not_to raise_error
        end
      end
    end
  end
end
