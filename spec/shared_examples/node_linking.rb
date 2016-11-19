module BehaviourNodeGraph
  shared_examples_for 'linking nodes together' do
    let(:next_node_klass) { BehaviourNodeGraph.define_simple_node {} }
    let(:node_count) { rand(2..10) }
    let(:next_nodes) do
      node_count.times.map { double(:node, :context= => nil, act: nil, next_node: nil) }
    end

    before { subject.next_nodes = next_nodes }

    describe '#executor' do
      let(:executor) { Faker::Lorem.word }
      before { subject.executor = executor }

      its(:executor) { is_expected.to eq(executor) }
    end

    describe '#next_nodes' do
      its(:next_nodes) { is_expected.to eq(next_nodes) }
    end

    describe '#add_to_graph' do
      let(:graph) { {} }
      let(:child_graph) { {} }
      let(:child_graph_two) { {} }
      let(:next_node) { next_node_klass.new_node }
      let(:next_node_two) { nil }
      let(:next_nodes) { [next_node] }

      before do
        next_node.add_to_graph(child_graph) if next_node
        next_node_two.add_to_graph(child_graph_two) if next_node_two
        subject.add_to_graph(graph)
      end

      it 'saves the next node' do
        expect(graph).to include(child_graph)
      end

      it 'references the next node' do
        expect(graph[node_id].next_nodes).to include(next_node.id)
      end

      context 'with multiple nodes' do
        let(:next_node_two) { next_node_klass.new_node }
        let(:next_nodes) { [next_node, next_node_two] }

        it 'saves the next node' do
          expect(graph).to include(child_graph_two)
        end

        it 'references the next node' do
          expect(graph[node_id].next_nodes).to include(next_node_two.id)
        end
      end

      context 'with no nodes set' do
        let(:next_node) { nil }
        let(:next_nodes) { [] }

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
      let(:next_nodes) { [next_node] }

      before { subject.add_to_graph(graph) }

      it 'should load the next node from the graph' do
        node = Node.load_from_graph(graph, node_id, node_graph)
        expect(node.next_nodes).to include(next_node)
      end

      context 'with multiple nodes' do
        let(:next_node_two) { next_node_klass.new_node }
        let(:next_nodes) { [next_node, next_node_two] }

        it 'should include the first node' do
          node = Node.load_from_graph(graph, node_id, node_graph)
          expect(node.next_nodes).to include(next_node)
        end

        it 'should include the second node' do
          node = Node.load_from_graph(graph, node_id, node_graph)
          expect(node.next_nodes).to include(next_node_two)
        end
      end

    end

    describe '#act' do
      let(:context) { Context.new }
      let(:next_node) { next_node_klass.new(SecureRandom.base64) }
      let(:next_nodes) { [next_node] }

      before do
        subject.context = context
        subject.next_nodes = next_nodes
      end

      it 'sets the child node context to the new context' do
        subject.act
        expect(next_node.context).to eq(subject.context)
      end

      it 'calls #act on the child node' do
        expect(next_node).to receive(:act)
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
        let(:next_node_two) { next_node_klass.new(SecureRandom.base64) }
        let(:next_nodes) { [next_node, next_node_two] }

        it 'calls #act on the first child' do
          expect(next_node).to receive(:act)
          subject.act
        end

        it 'calls #act on the second child' do
          expect(next_node_two).to receive(:act)
          subject.act
        end
      end

    end
  end
end
