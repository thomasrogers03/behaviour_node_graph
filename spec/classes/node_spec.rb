require 'rspec'

module BehaviourNodeGraph
  describe Node do

    let(:attribute) { :name }
    let(:attribute_value) { Faker::Lorem.word }
    let(:list_of_attributes) { [attribute] }
    let(:list_of_values) { [attribute_value] }
    let(:node_id) { SecureRandom.base64 }
    let(:node_klass) do
      Class.new(Struct.new(*list_of_attributes)) do
        include Node
      end
    end
    let(:node) { node_klass.new(node_id, *list_of_values) }

    describe '#add_to_graph' do
      let(:graph) { {} }

      subject { graph[node_id] }

      before { node.add_to_graph(graph) }

      its(:node_type) { is_expected.to eq(node_klass) }
      its(:id) { is_expected.to eq(node_id) }
      its(:name) { is_expected.to eq(attribute_value) }
    end
  end
end
