require 'rspec'

module BehaviourNodeGraph
  describe NodeCollection do

    let(:node_id) { SecureRandom.base64 }
    let(:node_klass) do
      Class.new do
        include Node

        def initialize_from_instructions

        end
      end
    end
    let(:list_of_nodes) { [] }
    let(:node_collection) { NodeCollection.new(node_id, list_of_nodes) }

    subject { node_collection }

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

  end
end