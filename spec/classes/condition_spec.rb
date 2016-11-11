require 'rspec'

module BehaviourNodeGraph
  describe Condition do
    let(:node_id) { SecureRandom.base64 }
    let(:node_klass) { BehaviourNodeGraph.define_simple_node {} }
    let(:lhs_node) { node_klass.new_node }
    let(:rhs_node) { node_klass.new_node }
    let(:list_of_lhs_nodes) { [lhs_node] }
    let(:list_of_rhs_nodes) { [rhs_node] }
    let(:condition_source) { SecureRandom.base64 }
    let(:condition) { Condition.new(node_id, condition_source, list_of_lhs_nodes, list_of_rhs_nodes) }

    subject { condition }

    describe 'inputs and outputs' do
      subject { Condition }

      its(:inputs) { is_expected.to eq([:condition]) }
      its(:outputs) { is_expected.to eq([]) }
      its(:output_nodes) { is_expected.to eq([:true, :false]) }
      its(:properties) { is_expected.to eq([]) }
    end

    describe '.load_from_graph' do
      let(:graph) { {} }
      let(:node_graph) { {} }

      subject { Node.load_from_graph(graph, node_id, node_graph) }

      before { condition.add_to_graph(graph) }

      its(:id) { is_expected.to eq(node_id) }
      its(:true_nodes) { is_expected.to eq(list_of_lhs_nodes) }
      its(:false_nodes) { is_expected.to eq(list_of_rhs_nodes) }

      context 'with multiple true/false nodes' do
        let(:lhs_node_two) { node_klass.new_node }
        let(:rhs_node_two) { node_klass.new_node }
        let(:list_of_lhs_nodes) { [lhs_node, lhs_node_two] }
        let(:list_of_rhs_nodes) { [rhs_node, rhs_node_two] }

        its(:true_nodes) { is_expected.to eq(list_of_lhs_nodes) }
        its(:false_nodes) { is_expected.to eq(list_of_rhs_nodes) }
      end

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

    describe '.new_node' do
      before { allow(SecureRandom).to receive(:base64).and_return(node_id) }
      subject { Condition.new_node(condition_source, list_of_lhs_nodes, list_of_rhs_nodes) }

      its(:id) { is_expected.to eq(node_id) }
      its(:true_nodes) { is_expected.to eq(list_of_lhs_nodes) }
      its(:false_nodes) { is_expected.to eq(list_of_rhs_nodes) }
      its(:condition_source) { is_expected.to eq(condition_source) }
    end

    its(:id) { is_expected.to eq(node_id) }
    its(:true_nodes) { is_expected.to eq(list_of_lhs_nodes) }
    its(:false_nodes) { is_expected.to eq(list_of_rhs_nodes) }
    its(:condition_source) { is_expected.to eq(condition_source) }

    context 'with multiple true/false nodes' do
      let(:lhs_node_two) { node_klass.new_node }
      let(:rhs_node_two) { node_klass.new_node }
      let(:list_of_lhs_nodes) { [lhs_node, lhs_node_two] }
      let(:list_of_rhs_nodes) { [rhs_node, rhs_node_two] }

      its(:true_nodes) { is_expected.to eq(list_of_lhs_nodes) }
      its(:false_nodes) { is_expected.to eq(list_of_rhs_nodes) }
    end

    describe '#add_to_graph' do
      let(:graph) { {} }
      let(:child_graph) { {} }

      subject { graph[node_id] }

      before do
        list_of_lhs_nodes.each { |node| node.add_to_graph(child_graph) }
        list_of_rhs_nodes.each { |node| node.add_to_graph(child_graph) }
        condition.add_to_graph(graph)
      end

      its(:node_type) { is_expected.to eq(Condition) }
      its(:id) { is_expected.to eq(node_id) }
      its(:true_nodes) { is_expected.to include(lhs_node.id) }
      its(:false_nodes) { is_expected.to include(rhs_node.id) }
      its(:condition_source) { is_expected.to eq(condition_source) }
      it { expect(graph).to include(child_graph) }

      context 'with multiple true/false nodes' do
        let(:lhs_node_two) { node_klass.new_node }
        let(:rhs_node_two) { node_klass.new_node }
        let(:list_of_lhs_nodes) { [lhs_node, lhs_node_two] }
        let(:list_of_rhs_nodes) { [rhs_node, rhs_node_two] }

        its(:true_nodes) { is_expected.to include(lhs_node.id) }
        its(:false_nodes) { is_expected.to include(rhs_node.id) }

        its(:true_nodes) { is_expected.to include(lhs_node_two.id) }
        its(:false_nodes) { is_expected.to include(rhs_node_two.id) }

        it { expect(graph).to include(child_graph) }
      end

      context 'when this node has already been added' do
        let(:node_value) { Faker::Lorem.sentence }
        let(:graph) { {node_id => node_value} }

        it { is_expected.to eq(node_value) }
      end
    end

    describe '#context' do
      let(:context) { SecureRandom.uuid }
      subject { condition }
      before { subject.context = context }
      its(:context) { is_expected.to eq(context) }
    end

    describe '#act' do
      let(:lhs_node_two) { node_klass.new_node }
      let(:rhs_node_two) { node_klass.new_node }
      let(:condition_value) { true }
      let(:context) { Context.new }

      before do
        context.values[condition_source] = condition_value
        subject.context = context
      end

      it 'should set the next_nodes' do
        subject.act
        expect(subject.next_nodes).to eq(list_of_lhs_nodes)
      end

      context 'with multiple true/false nodes' do
        let(:list_of_lhs_nodes) { [lhs_node, lhs_node_two] }
        let(:list_of_rhs_nodes) { [rhs_node, rhs_node_two] }

        it 'should set the next_nodes' do
          subject.act
          expect(subject.next_nodes).to eq(list_of_lhs_nodes)
        end
      end

      context 'when the condition value is false' do
        let(:condition_value) { false }

        it 'should set the next_node' do
          subject.act
          expect(subject.next_nodes).to eq(list_of_rhs_nodes)
        end

        context 'with multiple true/false nodes' do
          let(:list_of_lhs_nodes) { [lhs_node, lhs_node_two] }
          let(:list_of_rhs_nodes) { [rhs_node, rhs_node_two] }

          it 'should set the next_nodes' do
            subject.act
            expect(subject.next_nodes).to eq(list_of_rhs_nodes)
          end
        end
      end
    end

  end
end
