require 'rspec'

module BehaviourNodeGraph
  describe Condition do
    let(:node_id) { SecureRandom.base64 }
    let(:node_klass) { BehaviourNodeGraph.define_simple_node {} }
    let(:lhs_node) { node_klass.new_node }
    let(:rhs_node) { node_klass.new_node }
    let(:condition_source) { SecureRandom.base64 }
    let(:condition) { Condition.new(node_id, lhs_node, rhs_node, condition_source) }

    subject { condition }

    describe '.load_from_graph' do
      let(:graph) { {} }
      let(:node_graph) { {} }

      subject { Node.load_from_graph(graph, node_id, node_graph) }

      before { condition.add_to_graph(graph) }

      its(:id) { is_expected.to eq(node_id) }
      its(:true_node) { is_expected.to eq(lhs_node) }
      its(:false_node) { is_expected.to eq(rhs_node) }

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
    its(:true_node) { is_expected.to eq(lhs_node) }
    its(:false_node) { is_expected.to eq(rhs_node) }
    its(:condition_source) { is_expected.to eq(condition_source) }

    describe '#add_to_graph' do
      let(:graph) { {} }
      let(:child_graph) { {} }

      subject { graph[node_id] }

      before do
        lhs_node.add_to_graph(child_graph)
        rhs_node.add_to_graph(child_graph)
        condition.add_to_graph(graph)
      end

      its(:node_type) { is_expected.to eq(Condition) }
      its(:id) { is_expected.to eq(node_id) }
      its(:true_node) { is_expected.to eq(lhs_node.id) }
      its(:false_node) { is_expected.to eq(rhs_node.id) }
      its(:condition_source) { is_expected.to eq(condition_source) }
      it { expect(graph).to include(child_graph) }

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
      let(:condition_value) { true }
      let(:context) { Context.new }

      before do
        context.values[condition_source] = condition_value
        subject.context = context
      end

      it 'should call #act on the true node' do
        expect(lhs_node).to receive(:act)
        subject.act
      end

      it 'sets the context of the true node' do
        subject.act
        expect(lhs_node.context).to eq(context)
      end

      it 'should NOT call #act on the false node' do
        expect(rhs_node).not_to receive(:act)
        subject.act
      end

      context 'when the condition value is false' do
        let(:condition_value) { false }

        it 'should NOT call #act on the true node' do
          expect(lhs_node).not_to receive(:act)
          subject.act
        end

        it 'should call #act on the false node' do
          expect(rhs_node).to receive(:act)
          subject.act
        end

        it 'sets the context of the false node' do
          subject.act
          expect(rhs_node.context).to eq(context)
        end
      end
    end

  end
end
