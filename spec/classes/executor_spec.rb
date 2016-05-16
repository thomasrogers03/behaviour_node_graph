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

      context 'with a node' do
        let(:node_two) { nil }
        let(:node) { double(:node, act: nil, :context= => nil, next_node: node_two) }

        it 'sets the node context' do
          expect(node).to receive(:context=).with(context)
          subject.execute(node)
        end

        it 'should call #act on the node' do
          expect(node).to receive(:act)
          subject.execute(node)
        end

        context 'with another node' do
          let(:node_three) { nil }
          let(:node_two) { double(:node, act: nil, :context= => nil, next_node: node_three) }

          it 'sets the node context' do
            expect(node_two).to receive(:context=).with(context)
            subject.execute(node)
          end

          it 'should call #act on the node' do
            expect(node_two).to receive(:act)
            subject.execute(node)
          end

          context 'with many nodes linked together' do
            let(:node_three) { double(:node, act: nil, :context= => nil, next_node: nil) }

            it 'sets the node context' do
              expect(node_three).to receive(:context=).with(context)
              subject.execute(node)
            end

            it 'should call #act on the node' do
              expect(node_three).to receive(:act)
              subject.execute(node)
            end
          end
        end
      end
    end

  end
end
