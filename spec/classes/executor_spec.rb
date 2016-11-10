require 'rspec'

module BehaviourNodeGraph
  describe Executor do
    let(:node) { nil }
    let(:context) { Context.new }

    subject { Executor.new(context) }

    describe '#execute' do
      it 'does nothing' do
        subject.execute(node)
      end

      shared_examples_for 'performing an action on a node' do |node_name|
        let(:expected_node) { public_send(node_name) }

        it 'sets the node context' do
          expect(expected_node).to receive(:context=).with(context)
          subject.execute(node)
        end

        it 'should call #act on the node' do
          expect(expected_node).to receive(:act)
          subject.execute(node)
        end
      end

      context 'with a node' do
        let(:node_two) { nil }
        let(:node_list) { [] }
        let(:node) { double(:node, act: nil, :context= => nil, next_nodes: node_list) }

        it_behaves_like 'performing an action on a node', :node

        context 'with another node' do
          let(:node_three) { nil }
          let(:node_list_two) { [] }
          let(:node_two) { double(:node, act: nil, :context= => nil, next_nodes: node_list_two) }
          let(:node_list) { [node_two] }

          it_behaves_like 'performing an action on a node', :node_two

          context 'with multiple next nodes' do
            let(:node_three) { double(:node, act: nil, :context= => nil, next_nodes: nil) }
            let(:node_list) { [node_two, node_three] }

            it_behaves_like 'performing an action on a node', :node_two
            it_behaves_like 'performing an action on a node', :node_three
          end

          context 'with many nodes linked together' do
            let(:node_three) { double(:node, act: nil, :context= => nil, next_nodes: nil) }
            let(:node_list_two) { [node_three] }

            it_behaves_like 'performing an action on a node', :node_three
          end
        end
      end
    end

  end
end
