require 'rspec'

module BehaviourNodeGraph
  describe ImmediateExecutor do
    let(:node) { nil }
    let(:list_of_nodes) { nil }
    let(:context) { Context.new }

    subject { ImmediateExecutor.new(context) }

    describe '#execute' do
      it 'does nothing' do
        subject.execute(list_of_nodes)
      end

      shared_examples_for 'performing an action on a node' do |node_name|
        let(:expected_node) { public_send(node_name) }

        it 'sets the node context' do
          expect(expected_node).to receive(:context=).with(context)
          subject.execute(list_of_nodes)
        end

        it 'should call #act on the node' do
          expect(expected_node).to receive(:act)
          subject.execute(list_of_nodes)
        end
      end

      context 'with a node' do
        let(:list_of_nodes) { [node] }
        let(:node) { double(:node, act: nil, :context= => nil) }

        it_behaves_like 'performing an action on a node', :node

        context 'with another node' do
          let(:node_two) { double(:node, act: nil, :context= => nil) }
          let(:list_of_nodes) { [node, node_two] }

          it_behaves_like 'performing an action on a node', :node_two
        end
      end
    end

  end
end
